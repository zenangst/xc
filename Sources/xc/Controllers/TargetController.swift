import Foundation

enum Target: Equatable {
  case absolutePath(url: URL)
  case folder(url: URL)
  case wildcard(url: URL)
  case xed(url: URL)

  var url: URL {
    switch self {
    case .folder(let url),
        .absolutePath(let url),
        .wildcard(let url),
        .xed(let url):
      return url
    }
  }
}

final class TargetController {
  enum TargetControllerError: Error {
    case unableToResolveCurrentWorkingDirectory
  }
  let arguments: [String]
  let cwd: String
  let targets: [Target]

  init(arguments: [String],
       fileManager: FileManager,
       environment: [String: String]) throws {
    self.arguments = arguments

    if let pwd = environment["TEST_PWD"] {
      self.cwd = pwd.expandingTildeInPath
    } else if let pwd = environment["PWD"] {
      self.cwd = pwd.expandingTildeInPath
    } else if let cwd = arguments.first {
      self.cwd = cwd.expandingTildeInPath
    } else {
      throw TargetControllerError.unableToResolveCurrentWorkingDirectory
    }

    fileManager.changeCurrentDirectoryPath(self.cwd) 

    self.targets = Self.processPaths(Array(arguments.dropFirst()),
                                     cwd: cwd,
                                     fileManager: fileManager)
  }

  private static func processPaths(_ paths: [String], cwd: String,
                                   fileManager: FileManager) -> [Target] {
    var targets = [Target]()
    var paths = paths

    if paths.isEmpty {
      paths.append(cwd)
    }

    for path in paths {
      let resolvedPath = path.expandingTildeInPath
      let url = URL(fileURLWithPath: resolvedPath)
      let components = url.path.split(separator: ":")

      var isDirectory: ObjCBool = false

      if url.path.contains("*") {
        targets.append(.wildcard(url: url))
      } else if components.count == 2 {
        targets.append(.xed(url: url))
      } else if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
        if isDirectory.boolValue == true {
          targets.append(.folder(url: url))
        } else {
          targets.append(.absolutePath(url: url))
        }
      }
    }

    return targets
  }
}

extension String {
  var expandingTildeInPath: String { (self as NSString).expandingTildeInPath }
}
