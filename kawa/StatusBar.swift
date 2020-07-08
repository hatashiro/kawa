import AppKit
import Cocoa

class StatusBar: NSObject {
  static var preferenceWindowController: PreferenceWindowController?
  static let statusBar = NSStatusBar.system
  static var item: NSStatusItem? = nil

  static func initWithPreferenceWindowController(_ preferenceWindowController: PreferenceWindowController) {
    self.preferenceWindowController = preferenceWindowController

    if Settings.get(.showMenubarIcon, withDefaultValue: true) {
      createStatusBarItem()
    }
  }

  static func createStatusBarItem() {
    if item == nil {
      item = statusBar.statusItem(withLength: -1)

      let buttonImage = NSImage(named: "StatusItemIcon")
      buttonImage?.isTemplate = true

      let button = item!.button!
      button.target = self
      button.action = #selector(StatusBar.action(_:))
      button.image = buttonImage
      button.appearsDisabled = false;
      button.toolTip = "Click to open preferences"
    }
  }

  @objc static func action(_ sender: AnyObject) {
    preferenceWindowController!.showAndActivate(sender)
  }

  static func removeStatusBarItem() {
    if item != nil {
      statusBar.removeStatusItem(item!)
      item = nil
    }
  }
}
