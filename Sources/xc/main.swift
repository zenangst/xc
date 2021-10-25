import Foundation
import Cocoa

let target: Target
let argumentsWithoutPath = ProcessInfo.processInfo.arguments.dropFirst()

class Plugins {
  private(set) lazy var absolute = AbsolutePathController(xcode: xcode)
  private(set) lazy var folder = FolderController(fileManager: fileManager,
                                                  xcode: xcode)
  private(set) lazy var wildcard = WildcardController(fileManager: fileManager,
                                                      xcode: xcode)
  private(set) lazy var xed = XedController(fileManager: fileManager,
                                            xcode: xcode)

  private let fileManager: FileManager
  private let xcode: XcodeController

  init(fileManager: FileManager = .default,
       xcode: XcodeController? = nil) {
    self.fileManager = fileManager
    if let xcode = xcode {
      self.xcode = xcode
    } else {
      self.xcode = XcodeController(fileManager: fileManager)
    }
  }
}

final class App {
  let plugins = Plugins()

  init() throws { try main() }

  func main() throws {
    let targetController = try TargetController(
      arguments: ProcessInfo.processInfo.arguments,
      environment: ProcessInfo.processInfo.environment)

    Task.init(priority: .high) {
      do {
        try await receive(targetController.targets)
      } catch let error {
          Swift.print(error)
      }
      exit(EXIT_SUCCESS)
    }
  }

  func receive(_ targets: [Target]) async throws {
    for target in targets {
      switch target {
      case .absolutePath(let url):
        try await plugins.absolute.receive(url)
      case .folder(let url):
        try await plugins.folder.receive(url)
      case .wildcard(let url):
        try await plugins.wildcard.receive(url)
      case .xed(let url):
        try await plugins.xed.receive(url)
      }
    }
  }
}

_ = try? App()
dispatchMain()

