import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusBar = StatusBar.shared

  var justLaunched: Bool = true

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if PermanentStorage.launchedForTheFirstTime {
      PermanentStorage.launchedForTheFirstTime = false
    }
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    if !justLaunched || PermanentStorage.launchedForTheFirstTime {
      showPreferences()
    }

    if justLaunched {
      justLaunched = false
    }
  }

  @IBAction func showPreferences(_ sender: AnyObject? = nil) {
    MainWindowController.shared.showAndActivate(self)
  }

  @IBAction func hidePreferences(_ sender: AnyObject?) {
    MainWindowController.shared.close()
  }
}
