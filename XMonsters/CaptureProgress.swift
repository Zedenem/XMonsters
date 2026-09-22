import Foundation
import Observation

/// Local-only storage. A single versioned payload also acts as the migration marker.
/// Legacy keys are retained so migration never destroys the original save.
@MainActor
@Observable
final class CaptureProgress {
    static let storageKey = "com.zedenem.XMonsters.captureProgress.v1"

    private struct Snapshot: Codable {
        let version: Int
        var counts: [String: Int]
    }

    enum StorageError: Error {
        case invalidSnapshot
        case unsupportedVersion(Int)
        case unknownMonster(String)
    }

    private let defaults: UserDefaults
    private let knownIDs: Set<String>
    private(set) var counts: [String: Int]

    init(defaults: UserDefaults = .standard) throws {
        self.defaults = defaults
        knownIDs = Set(MonsterCatalogue.monsters.map(\.id))

        if let existing = defaults.object(forKey: Self.storageKey) {
            // Do not replace corrupt or newer data with a legacy migration.
            guard let data = existing as? Data else { throw StorageError.invalidSnapshot }
            let snapshot = try JSONDecoder().decode(Snapshot.self, from: data)
            guard snapshot.version == 1 else {
                throw StorageError.unsupportedVersion(snapshot.version)
            }
            counts = snapshot.counts.mapValues { max(0, min(10, $0)) }
        } else {
            counts = Dictionary(uniqueKeysWithValues: MonsterCatalogue.monsters.map {
                ($0.id, max(0, min(10, defaults.integer(forKey: $0.legacyKey))))
            })
            try persist(counts)
        }
    }

    func count(for monsterID: String) -> Int {
        counts[monsterID, default: 0]
    }

    func setCount(_ count: Int, for monsterID: String) throws {
        guard knownIDs.contains(monsterID) else { throw StorageError.unknownMonster(monsterID) }
        var updated = counts
        updated[monsterID] = max(0, min(10, count))
        try persist(updated)
        counts = updated
    }

    var overall: CaptureSummary {
        CaptureSummary(monsterIDs: MonsterCatalogue.monsters.map(\.id), counts: counts)
    }

    func summary(for zone: CaptureZone, threshold: Int = 10) -> CaptureSummary {
        CaptureSummary(
            monsterIDs: MonsterCatalogue.monsters.filter { $0.zoneID == zone.id }.map(\.id),
            counts: counts, threshold: threshold
        )
    }

    func summary(for family: CaptureFamily, threshold: Int? = nil) -> CaptureSummary {
        CaptureSummary(monsterIDs: family.monsterIDs, counts: counts,
                       threshold: threshold ?? family.threshold)
    }

    private func persist(_ updated: [String: Int]) throws {
        let data = try JSONEncoder().encode(Snapshot(version: 1, counts: updated))
        defaults.set(data, forKey: Self.storageKey)
    }
}
