import XCTest
@testable import xc

final class AbsolutePathControllerTests: XCTestCase {
  func testReceiveUrl() async throws {
    let xcode = XcodeControllerMock()
    let absolute = AbsolutePathController(xcode: xcode)
    let url = URL(fileURLWithPath: "foo/bar")
    let expectedValue = XcodeAction.workspace(url: url)

    XCTAssertNil(xcode.previousAction)

    try await absolute.receive(url)

    XCTAssertEqual(expectedValue, xcode.previousAction)
  }
}
