import XCTest
@testable import XMonsters

@MainActor
final class XMonstersTests: XCTestCase {
    func testAppIdentityIsPreserved() {
        XCTAssertEqual(AppIdentity.name, "XMonsters")
    }

    private func withDefaults(_ body: (UserDefaults) throws -> Void) rethrows {
        let suite = "XMonstersTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        try body(defaults)
    }

    func testCatalogueIntegrity() {
        let monsters = MonsterCatalogue.monsters
        XCTAssertEqual(monsters.count, 102)
        XCTAssertEqual(Set(monsters.map(\.id)).count, 102)
        XCTAssertEqual(Set(monsters.map(\.legacyKey)).count, 102)
        XCTAssertEqual(MonsterCatalogue.zones.count, 13)
        XCTAssertEqual(MonsterCatalogue.families.count, 14)
        let zoneIDs = Set(MonsterCatalogue.zones.map(\.id))
        XCTAssertTrue(monsters.allSatisfy { zoneIDs.contains($0.zoneID) })
        let ids = Set(monsters.map(\.id))
        for family in MonsterCatalogue.families {
            XCTAssertFalse(family.monsterIDs.isEmpty)
            XCTAssertEqual(Set(family.monsterIDs).count, family.monsterIDs.count)
            XCTAssertTrue(Set(family.monsterIDs).isSubset(of: ids))
        }
        XCTAssertTrue(monsters.contains { $0.frenchName == "Couguar" })
        XCTAssertTrue(monsters.contains { $0.frenchName == "Maître Couguar" })
        XCTAssertNotEqual(monsters.first { $0.frenchName == "Pampa" }?.id,
                          monsters.first { $0.frenchName == "Pampa ?" }?.id)
    }

    func testEveryLegacyKeyMigratesOnceWithoutDeletingOriginals() throws {
        try withDefaults { defaults in
            for (index, monster) in MonsterCatalogue.monsters.enumerated() {
                defaults.set(index % 11, forKey: monster.legacyKey)
            }
            let progress = try CaptureProgress(defaults: defaults)
            for (index, monster) in MonsterCatalogue.monsters.enumerated() {
                XCTAssertEqual(progress.count(for: monster.id), index % 11)
                XCTAssertEqual(defaults.integer(forKey: monster.legacyKey), index % 11)
            }
            try progress.setCount(9, for: "dingo")
            defaults.set(1, forKey: "Dingo")
            let reopened = try CaptureProgress(defaults: defaults)
            XCTAssertEqual(reopened.count(for: "dingo"), 9)
        }
    }

    func testFreshInstallAndCountBoundsPersist() throws {
        try withDefaults { defaults in
            let progress = try CaptureProgress(defaults: defaults)
            XCTAssertEqual(progress.overall.captured, 0)
            XCTAssertEqual(progress.overall.target, 1020)
            try progress.setCount(99, for: "dingo")
            try progress.setCount(-1, for: "condor")
            let reopened = try CaptureProgress(defaults: defaults)
            XCTAssertEqual(reopened.count(for: "dingo"), 10)
            XCTAssertEqual(reopened.count(for: "condor"), 0)
            XCTAssertThrowsError(try reopened.setCount(4, for: "unknown"))
        }
    }

    func testLegacyOutOfRangeCountsAreClamped() throws {
        try withDefaults { defaults in
            defaults.set(99, forKey: "Flambos")
            defaults.set(-5, forKey: "Emildea")
            let progress = try CaptureProgress(defaults: defaults)
            XCTAssertEqual(progress.count(for: "flambos"), 10)
            XCTAssertEqual(progress.count(for: "emildea"), 0)
        }
    }

    func testCorruptAndFutureSavesAreNotOverwritten() throws {
        try withDefaults { defaults in
            for data in [Data("broken".utf8), Data(#"{"version":2,"counts":{"dingo":8}}"#.utf8)] {
                defaults.set(data, forKey: CaptureProgress.storageKey)
                XCTAssertThrowsError(try CaptureProgress(defaults: defaults))
                XCTAssertEqual(defaults.data(forKey: CaptureProgress.storageKey), data)
            }
        }
    }

    func testFamilyCorrectionsAndThresholds() throws {
        let insects = try XCTUnwrap(MonsterCatalogue.families.first { $0.id == "insectes" })
        XCTAssertTrue(insects.monsterIDs.contains("emildea"))
        XCTAssertFalse(insects.monsterIDs.contains("larva"))
        let mages = try XCTUnwrap(MonsterCatalogue.families.first { $0.id == "mages-volants" })
        XCTAssertTrue(mages.monsterIDs.contains("galkimasera"))
        XCTAssertFalse(mages.monsterIDs.contains("epehj"))
        let giants = try XCTUnwrap(MonsterCatalogue.families.first { $0.id == "geants-de-fer" })
        XCTAssertTrue(giants.monsterIDs.contains("ekarissor"))
        XCTAssertFalse(giants.monsterIDs.contains("asherah"))
        for family in MonsterCatalogue.families {
            let counts = Dictionary(uniqueKeysWithValues: family.monsterIDs.map { ($0, family.threshold) })
            XCTAssertEqual(CaptureSummary(monsterIDs: family.monsterIDs, counts: counts,
                                          threshold: family.threshold).missingCaptures, 0)
        }
        let partial = CaptureSummary(monsterIDs: ["a", "b", "c"],
                                     counts: ["a": 10, "b": 2], threshold: 3)
        XCTAssertEqual(partial.missingCaptures, 4)
        XCTAssertEqual(partial.missingMonsterIDs, ["b", "c"])
        XCTAssertEqual(partial.completedSpecies, 1)
    }
}
