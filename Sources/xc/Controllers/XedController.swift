import Foundation

final class XedController {
  private let xcode: XcodeControlling

  init(xcode: XcodeControlling) {
    self.xcode = xcode
  }
  
  func receive(_ url: URL) async throws {
    try await xcode.perform(.xed(url: url))
  }
}

