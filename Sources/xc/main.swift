import Foundation
import Cocoa

let target: Target
let argumentsWithoutPath = ProcessInfo.processInfo.arguments.dropFirst()

if let argument = argumentsWithoutPath.last {
  let path = (argument as NSString).expandingTildeInPath
  target = .provided(url: URL(fileURLWithPath: path))
} else {
  guard let pwd = ProcessInfo.processInfo.environment["PWD"] else {
    throw XCError.unableToFindEnvironmentVariablePWD
  }
  target = .environment(url: URL(fileURLWithPath: pwd))
}

let patterns: Set<String> = [
  "Package.swift",
  "xcworkspace",
  "xcodeproj",
]

let dispatchGroup = DispatchGroup()

class App {
  init() throws { try main() }

  func main() throws {
    let xcodeUrl = URL(fileURLWithPath: "/Applications/Xcode.app")
    let configuration = NSWorkspace.OpenConfiguration()
    let fileManager = FileManager.default

    if !fileManager.fileExists(atPath: xcodeUrl.path) {
      throw XCError.unableToFindXcode
    }

    if fileManager.fileExists(atPath: target.url.path),
       (try? target.url.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == false {
      dispatchGroup.enter()
      NSWorkspace.shared.open([target.url], withApplicationAt: xcodeUrl,
                              configuration: configuration) { _, _ in
        dispatchGroup.leave()
        exit(EXIT_SUCCESS)
      }
    } else {
      let directoryUrl = target.url
      let contents = fileManager.enumerator(at: directoryUrl.resolvingSymlinksInPath(),
                                            includingPropertiesForKeys: nil,
                                            options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants],
                                            errorHandler: nil)

      var match: URL?
      while let fileUrl = contents?.nextObject() as? URL {
        let lastComponent = fileUrl.lastPathComponent
        let fileExtension = fileUrl.pathExtension

        if patterns.contains(lastComponent) {
          match = fileUrl
          break
        } else if patterns.contains(fileExtension) {
          match = fileUrl
          break
        }
      }

      guard let match = match else {
        throw XCError.noMatchFound
      }

      dispatchGroup.enter()
      NSWorkspace.shared.open([match], withApplicationAt: xcodeUrl,
                              configuration: configuration, completionHandler: { _, _ in
        dispatchGroup.leave()
        exit(EXIT_SUCCESS)
      })
    }
    dispatchMain()
  }
}

_ = try? App()


