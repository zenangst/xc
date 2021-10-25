import XCTest
@testable import xc

final class TargetControllerTests: XCTestCase {
  func testProcessingPaths() throws {
    // The first argument is always the path
    let arguments = [
      Fixture.package.url.path,
      "Package.swift",
      "Package.*",
      "*.swift",
      "Package.swift:2"
    ]
    let environment: [String: String] = [
      "PWD": Fixture.package.url.path
    ]

    let controller = try TargetController(arguments: arguments,
                                          fileManager: .default,
                                          environment: environment)

    let expectedValues: [Target] = [
      .absolutePath(url: URL(fileURLWithPath: "Package.swift", relativeTo: Fixture.package.url)),
      .wildcard(url: URL(fileURLWithPath: "Package.*", relativeTo: Fixture.package.url)),
      .wildcard(url: URL(fileURLWithPath: "*.swift", relativeTo: Fixture.package.url)),
      .xed(url: URL(fileURLWithPath: "Package.swift:2", relativeTo: Fixture.package.url))
    ]

    guard controller.targets.count == expectedValues.count else {
      XCTFail("There is a count mismatch")
      return
    }

    XCTAssertEqual(expectedValues[0], controller.targets[0])
    XCTAssertEqual(expectedValues[1], controller.targets[1])
    XCTAssertEqual(expectedValues[2], controller.targets[2])
    XCTAssertEqual(expectedValues[3], controller.targets[3])
  }

  func testProcessingPathsWithFolders() throws {
    // The first argument is always the path
    let arguments = [
      Fixture.project.url.path,
      "Project.xcodeproj"
    ]
    let environment: [String: String] = [
      "PWD": Fixture.project.url.path
    ]

    let controller = try TargetController(arguments: arguments,
                                          fileManager: .default,
                                          environment: environment)
    let expectedValues: [Target] = [
      .folder(url: URL(fileURLWithPath: "Project.xcodeproj", relativeTo: Fixture.project.url)),
    ]

    guard controller.targets.count == expectedValues.count else {
      XCTFail("There is a count mismatch")
      return
    }

    XCTAssertEqual(expectedValues[0], controller.targets[0])
  }
}
