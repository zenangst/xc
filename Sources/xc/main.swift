import Foundation

final class App {
  let plugins = Plugins()

  init(fileManager: FileManager = .default) throws {
    try main(fileManager)
  }

  func main(_ fileManager: FileManager) throws {
    let targetController = try TargetController(
      arguments: ProcessInfo.processInfo.arguments,
      fileManager: fileManager,
      environment: ProcessInfo.processInfo.environment)

    Task(priority: .high) {
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

