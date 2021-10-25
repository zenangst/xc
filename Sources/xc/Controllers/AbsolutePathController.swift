import Foundation

final class AbsolutePathController {
  let xcode: XcodeControlling

  init(xcode: XcodeControlling) {
    self.xcode = xcode
  }

  func receive(_ url: URL) async throws {
    try await xcode.perform(.workspace(url: url))
  }
}
