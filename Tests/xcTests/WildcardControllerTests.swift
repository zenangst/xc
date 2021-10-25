import XCTest
@testable import xc

final class WildcardControllerTests: XCTestCase {
  func testReceiveUrl() async throws {
    let xcode = XcodeControllerMock()
    let wildcard = WildcardController(xcode: xcode)
    let url = Fixture.custom("Package.*").url
    let expectedValue = XcodeAction.openCommand(url: url)

    XCTAssertNil(xcode.previousAction)

    try await wildcard.receive(url)

    XCTAssertEqual(xcode.previousAction, expectedValue)
  }
}
