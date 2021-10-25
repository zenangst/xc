import Foundation

final class WildcardController {
  private let xcode: XcodeControlling

  init(xcode: XcodeControlling) {
    self.xcode = xcode
  }

  func receive(_ url: URL) async throws {
    try await xcode.perform( .openCommand(url: url))
  }
}
