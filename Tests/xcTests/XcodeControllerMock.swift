import Foundation
@testable import xc

final class XcodeControllerMock: XcodeControlling {
  var previousAction: XcodeAction?

  func perform(_ action: XcodeAction) async throws {
    previousAction = action
  }
}
