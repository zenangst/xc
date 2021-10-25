import XCTest
@testable import xc

final class XedControllerTests {
  func testReceiveUrl() async throws {
    let xcode = XcodeControllerMock()
    let xed = XedController(xcode: xcode)
    let url = URL(fileURLWithPath: "foo/bar:20")
    let expectedValue = XcodeAction.xed(url: url)

    XCTAssertNil(xcode.previousAction)

    try await xed.receive(url)

    XCTAssertEqual(expectedValue, xcode.previousAction)
  }
}
