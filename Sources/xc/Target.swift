import Foundation

enum Target {
  case provided(url: URL)
  case environment(url: URL)
  var url: URL {
    switch self {
    case .environment(let url):
      return url
    case .provided(let url):
      return url
    }
  }
}
