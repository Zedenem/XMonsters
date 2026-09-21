import XCTest
@testable import XMonsters

final class XMonstersTests: XCTestCase {
    func testAppIdentityIsPreserved() {
        XCTAssertEqual(AppIdentity.name, "XMonsters")
    }
}
