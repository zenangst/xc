import Foundation

final class XedController {
  private let fileManager: FileManager
  private let xcode: XcodeController


  init(fileManager: FileManager = .default, xcode: XcodeController? = nil) {
    self.fileManager = fileManager
    if let xcode = xcode {
      self.xcode = xcode
    } else {
      self.xcode = XcodeController(fileManager: fileManager)
    }
  }
  
  func receive(_ url: URL) async throws {
    try await xcode.open(using: .xed(url: url))
  }
}

