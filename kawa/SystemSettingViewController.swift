import Cocoa

class SystemSettingViewController: NSViewController {
    @IBOutlet var showMenubarIconCheckbox: NSButton!
    @IBOutlet weak var showNotificationCheckbox: NSButton!
    @IBOutlet var quitAppButton: NSButton!
    @IBOutlet var projectPageLink: HyperlinkTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        quitAppButton.target = self
        quitAppButton.action = #selector(SystemSettingViewController.quitApp(_:))

        showMenubarIconCheckbox.target = self
        showMenubarIconCheckbox.action = #selector(SystemSettingViewController.setShowMenubarIcon(_:))
        var isOn: Bool = Settings.get(.showMenubarIcon, withDefaultValue: true)
        showMenubarIconCheckbox.state = isOn ? NSControl.StateValue.on : NSControl.StateValue.off

        isOn = Settings.get(.showNotification, withDefaultValue: false)
        showNotificationCheckbox.state = isOn ? NSControl.StateValue.on : NSControl.StateValue.off

        let urlString = projectPageLink.stringValue
        let url = URL(string: "https://" + urlString)
        projectPageLink.setURL(url!)
    }

    @objc func quitApp(_ sender: AnyObject) {
        NSApplication.shared.terminate(nil)
    }

    @objc func setShowMenubarIcon(_ sender: AnyObject) {
        let isOn: Bool = showMenubarIconCheckbox.state == NSControl.StateValue.on
        Settings.set(.showMenubarIcon, toValue: isOn)

        if isOn {
            StatusBar.createStatusBarItem()
        } else {
            StatusBar.removeStatusBarItem()
        }
    }

    @IBAction func showNotification(_ sender: NSButton) {
        Settings.set(.showNotification, toValue: sender.state == NSControl.StateValue.on)
    }
}
