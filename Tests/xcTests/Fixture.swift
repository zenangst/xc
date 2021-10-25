import Foundation

enum Fixture {
  case package
  case project
  case workspace
  case custom(String)

  var url: URL {
    switch self {
    case .custom(let string):
      return sourceRoot.appendingPathComponent(string)
    case .package:
      return sourceRoot.appendingPathComponent("Package")
    case .project:
      return sourceRoot.appendingPathComponent("Project")
    case .workspace:
      return sourceRoot.appendingPathComponent("Workspace")
    }
  }

  private var sourceRoot: URL {
    return URL(fileURLWithPath: "\(#file)")
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .appendingPathComponent("Fixtures")
  }
}
