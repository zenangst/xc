import Foundation
import Cocoa

final class FolderController {
  enum FolderError: Error {
    case unableToFindMatch(url: URL)
  }

  let knownFileTypes: Set<String> = [
    "Package.swift",
    "xcworkspace",
    "xcodeproj",
  ]

  private let fileManager: FileManager
  private let xcode: XcodeControlling

  init(fileManager: FileManager = .default, xcode: XcodeControlling) {
    self.fileManager = fileManager
    self.xcode = xcode
  }

  func receive(_ url: URL) async throws {
    let options: FileManager.DirectoryEnumerationOptions = [
      .skipsHiddenFiles,
      .skipsSubdirectoryDescendants
    ]
    let contents = fileManager.enumerator(at: url.resolvingSymlinksInPath(),
                                          includingPropertiesForKeys: nil,
                                          options: options,
                                          errorHandler: nil)
    var match: URL?
    while let fileUrl = contents?.nextObject() as? URL {
      let lastComponent = fileUrl.lastPathComponent
      let fileExtension = fileUrl.pathExtension

      if knownFileTypes.contains(lastComponent) {
        match = fileUrl
        break
      } else if knownFileTypes.contains(fileExtension) {
        match = fileUrl
        break
      }
    }

    guard let match = match else {
      throw FolderError.unableToFindMatch(url: url)
    }

    try await xcode.perform(.workspace(url: match))
  }
}
