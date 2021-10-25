import Foundation

enum XcodeAction: Equatable {
  case openCommand(url: URL)
  case workspace(url: URL)
  case xed(url: URL)
}
