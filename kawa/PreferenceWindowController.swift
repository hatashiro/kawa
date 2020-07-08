import Cocoa

class PreferenceWindowController: NSWindowController, NSWindowDelegate {
  static let shared: PreferenceWindowController = {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateController(withIdentifier: "Preference")
      as! PreferenceWindowController
  }()

  func showAndActivate(_ sender: AnyObject?) {
    self.showWindow(sender)
    self.window?.makeKeyAndOrderFront(sender)
    NSApp.activate(ignoringOtherApps: true)
  }

  func windowWillClose(_ notification: Notification) {
    deactivate()
  }

  func deactivate() {
    // focus an application owning the menu bar
    let workspace = NSWorkspace.shared
    workspace.menuBarOwningApplication?.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
  }
}
