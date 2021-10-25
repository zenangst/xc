import Foundation

final class AbsolutePathController {
  let xcode: XcodeController

  init(xcode: XcodeController) {
    self.xcode = xcode
  }

  func receive(_ url: URL) async throws {
    try await xcode.open(using: .workspace(url: url))
  }
}
