import AppKit
import Cocoa

class StatusBar {
  static let shared: StatusBar = StatusBar()

  let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

  init() {
    let button = item.button!

    let buttonImage = NSImage(named: "StatusItemIcon")
    buttonImage?.isTemplate = true

    button.target = self
    button.action = #selector(StatusBar.action(_:))
    button.image = buttonImage
    button.appearsDisabled = false;
    button.toolTip = "Click to open preferences"
  }

  @objc func action(_ sender: NSButton) {
    PreferenceWindowController.shared.showAndActivate(sender)
  }
}
