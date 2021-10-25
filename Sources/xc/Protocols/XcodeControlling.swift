import Foundation

protocol XcodeControlling {
  func perform(_ action: XcodeAction) async throws
}
