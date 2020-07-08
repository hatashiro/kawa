import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferenceWindowController: PreferenceWindowController!
    var justLaunched: Bool = true
    var launchedForTheFirstTime: Bool = Settings.get(.launchedForTheFirstTime, withDefaultValue: true)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        InputSourceManager.initialize()
        preferenceWindowController = instantiatePreferenceWindowController()
        StatusBar.initWithPreferenceWindowController(preferenceWindowController)

        if launchedForTheFirstTime {
            Settings.set(.launchedForTheFirstTime, toValue: false)
        }
    }

    func instantiatePreferenceWindowController() -> PreferenceWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateController(withIdentifier: "Preference") as! PreferenceWindowController
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        if !justLaunched || launchedForTheFirstTime {
            preferenceWindowController.showAndActivate(self)
        }

        if justLaunched {
            justLaunched = false
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @IBAction func showPreferences(_ sender: AnyObject?) {
        preferenceWindowController.showAndActivate(self)
    }

    @IBAction func hidePreferences(_ sender: AnyObject?) {
        preferenceWindowController.close()
    }
}
