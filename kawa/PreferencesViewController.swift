import Cocoa

class PreferencesViewController: NSViewController {
  @IBOutlet weak var showNotificationCheckbox: NSButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    showNotificationCheckbox.state = PermanentStorage.showsNotification.stateValue
  }

  @IBAction func quitApp(_ sender: NSButton) {
    NSApplication.shared.terminate(nil)
  }

  @IBAction func showNotification(_ sender: NSButton) {
    let shouldShow = sender.state.boolValue
    PermanentStorage.showsNotification = shouldShow

    if shouldShow {
      NotificationManager.requestAuthorizationIfNeeded { _ in }
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
