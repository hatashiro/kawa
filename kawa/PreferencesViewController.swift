import Cocoa
import ServiceManagement

class PreferencesViewController: NSViewController {
  @IBOutlet weak var showNotificationCheckbox: NSButton!
  @IBOutlet weak var launchAtLoginCheckbox: NSButton!
  @IBOutlet weak var launchAtLoginStatus: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    showNotificationCheckbox.state = PermanentStorage.showsNotification.stateValue
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshLaunchAtLogin),
      name: NSApplication.didBecomeActiveNotification,
      object: nil
    )
    refreshLaunchAtLogin()
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    refreshLaunchAtLogin()
  }

  @IBAction func quitApp(_ sender: NSButton) {
    NSApplication.shared.terminate(nil)
  }

  @IBAction func showNotification(_ sender: NSButton) {
    PermanentStorage.showsNotification = sender.state.boolValue
  }

  @IBAction func launchAtLogin(_ sender: NSButton) {
    guard #available(macOS 13.0, *) else { return }

    do {
      if sender.state.boolValue {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
    } catch {
      let alert = NSAlert(error: error)
      alert.messageText = "Could not update launch at login"
      alert.runModal()
    }

    refreshLaunchAtLogin()
  }

  @objc private func refreshLaunchAtLogin() {
    guard #available(macOS 13.0, *) else {
      launchAtLoginCheckbox.isEnabled = false
      launchAtLoginCheckbox.state = .off
      launchAtLoginStatus.stringValue =
        "macOS 12 or earlier: add Kawa in System Preferences > Users & Groups > Login Items."
      return
    }

    launchAtLoginCheckbox.isEnabled = true
    switch SMAppService.mainApp.status {
    case .enabled:
      launchAtLoginCheckbox.state = .on
      launchAtLoginStatus.stringValue = ""
    case .requiresApproval:
      launchAtLoginCheckbox.state = .on
      launchAtLoginStatus.stringValue =
        "Allow Kawa in System Settings > General > Login Items."
    case .notRegistered:
      launchAtLoginCheckbox.state = .off
      launchAtLoginStatus.stringValue = ""
    case .notFound:
      launchAtLoginCheckbox.state = .off
      launchAtLoginStatus.stringValue = "The login item was not found. Enable it to register Kawa."
    @unknown default:
      launchAtLoginCheckbox.isEnabled = false
      launchAtLoginCheckbox.state = .off
      launchAtLoginStatus.stringValue = "The login item status is unavailable."
    }
  }
}

private extension Bool {
  var stateValue: NSControl.StateValue {
    return self ? .on : .off;
  }
}

private extension NSControl.StateValue {
  var boolValue: Bool {
    return self == .on;
  }
}
