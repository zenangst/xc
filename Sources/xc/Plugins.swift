import Foundation

final class Plugins {
  private(set) lazy var absolute = AbsolutePathController(xcode: xcode)
  private(set) lazy var folder = FolderController(fileManager: fileManager,
                                                  xcode: xcode)
  private(set) lazy var wildcard = WildcardController(xcode: xcode)
  private(set) lazy var xed = XedController(xcode: xcode)

  private let fileManager: FileManager
  private let xcode: XcodeController

  init(fileManager: FileManager = .default,
       xcode: XcodeController? = nil) {
    self.fileManager = fileManager
    if let xcode = xcode {
      self.xcode = xcode
    } else {
      self.xcode = XcodeController(fileManager: fileManager)
    }
  }
}
