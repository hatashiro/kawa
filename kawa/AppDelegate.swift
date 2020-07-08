import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var preferenceWindowController: PreferenceWindowController!
  var justLaunched: Bool = true

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    preferenceWindowController = instantiatePreferenceWindowController()
    StatusBar.initWithPreferenceWindowController(preferenceWindowController)

    if Storage.launchedForTheFirstTime {
      Storage.launchedForTheFirstTime = false
    }
  }

  func instantiatePreferenceWindowController() -> PreferenceWindowController {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateController(withIdentifier: "Preference") as! PreferenceWindowController
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    if !justLaunched || Storage.launchedForTheFirstTime {
      preferenceWindowController.showAndActivate(self)
    }

    if justLaunched {
      justLaunched = false
    }
  }

  @IBAction func showPreferences(_ sender: AnyObject?) {
    preferenceWindowController.showAndActivate(self)
  }

  @IBAction func hidePreferences(_ sender: AnyObject?) {
    preferenceWindowController.close()
  }
}
