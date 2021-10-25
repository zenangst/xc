import XCTest
@testable import xc

final class FolderControllerTests: XCTestCase {
  func testReceiveUrlPackage() async throws {
    let xcode = XcodeControllerMock()
    let folderController = FolderController(xcode: xcode)
    let expectedValue = XcodeAction.workspace(url: Fixture.package.url.appendingPathComponent("Package.swift"))

    XCTAssertNil(xcode.previousAction)

    try await folderController.receive(Fixture.package.url)

    XCTAssertEqual(xcode.previousAction, expectedValue)
  }

  func testReceiveUrlProject() async throws {
    let xcode = XcodeControllerMock()
    let folderController = FolderController(xcode: xcode)
    let expectedValue = XcodeAction.workspace(url: Fixture.project.url.appendingPathComponent("Project.xcodeproj"))

    XCTAssertNil(xcode.previousAction)

    try await folderController.receive(Fixture.project.url)

    XCTAssertEqual(xcode.previousAction, expectedValue)
  }

  func testReceiveUrlWorkspace() async throws {
    let xcode = XcodeControllerMock()
    let folderController = FolderController(xcode: xcode)
    let expectedValue = XcodeAction.workspace(url: Fixture.workspace.url.appendingPathComponent("Workspace.xcworkspace"))

    XCTAssertNil(xcode.previousAction)

    try await folderController.receive(Fixture.workspace.url)
    
    XCTAssertEqual(xcode.previousAction, expectedValue)
  }
}
