import Cocoa
import Foundation

final class XcodeController: XcodeControlling {
  private let configuration: NSWorkspace.OpenConfiguration
  private let fileManager: FileManager
  private let workspace: NSWorkspace

  init(configuration: NSWorkspace.OpenConfiguration = .init(),
       fileManager: FileManager = .default,
       workspace: NSWorkspace = .shared) {
    self.configuration = configuration
    self.fileManager = fileManager
    self.workspace = workspace
  }

  public func perform(_ action: XcodeAction) async throws {
    switch action {
    case .openCommand(let url):
      try await openWithOpenCommand(url)
    case .workspace(let url):
      try await openWithWorkspace(url)
    case .xed(let url):
      try await openWithXed(url)
    }
  }

  // MARK: Private methods

  private func openWithWorkspace(_ url: URL) async throws {
    let xcodeUrl = URL(fileURLWithPath: "/Applications/Xcode.app")
    if !fileManager.fileExists(atPath: xcodeUrl.path) {
      throw XCError.unableToFindXcode
    }

    try await workspace.open([url], withApplicationAt: xcodeUrl,
                         configuration: configuration)
  }

  private func openWithXed(_ url: URL) async throws {
    let path = url.path.replacingOccurrences(of: ":", with: " -line ")
    runShellscript("/usr/bin/xed \(path)", url: url)
  }

  private func openWithOpenCommand(_ url: URL) async throws {
    runShellscript("/usr/bin/open -a Xcode \(url.path)", url: url)
  }

  private func runShellscript(_ command: String, url: URL) {
    let cwd = url.deletingLastPathComponent()
    let ctx = Process().shell(command, at: cwd)

    if let error = ctx.errorController.string {
      Swift.print("Error: \(error)")
    }
  }
}

private struct ProcessContext {
  let task: Process
  let outputController: OutputController
  let errorController: OutputController
}

private extension Process {
  func shell(_ command: String, at url: URL) -> ProcessContext {
    let outputController = OutputController()
    let errorController = OutputController()
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    launchPath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
    arguments = ["-i", "-l", command]
    standardOutput = outputPipe
    standardError = errorPipe
    currentDirectoryURL = url

    Swift.print(command)

    var data = Data()
    var error = Data()

    do {
      try run()

      data = outputPipe.fileHandleForReading.readDataToEndOfFile()
      error = errorPipe.fileHandleForReading.readDataToEndOfFile()

      outputController.string = String(data: data, encoding: .utf8)
      errorController.string = String(data: error, encoding: .utf8)

      waitUntilExit()
    } catch let error {
      Swift.print("error: \(error)")
    }

    return ProcessContext(task: self,
                          outputController: outputController,
                          errorController: errorController)
  }
}

private class OutputController {
  var string: String?
}

fileprivate extension Data {
  func toString() -> String {
    guard let output = String(data: self, encoding: .utf8) else { return "" }

    guard !output.hasSuffix("\n") else {
      let endIndex = output.index(before: output.endIndex)
      return String(output[..<endIndex])
    }

    return output
  }
}
