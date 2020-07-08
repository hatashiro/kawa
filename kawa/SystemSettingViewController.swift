import Cocoa

class SystemSettingViewController: NSViewController {
  @IBOutlet weak var showNotificationCheckbox: NSButton!
  @IBOutlet var quitAppButton: NSButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    quitAppButton.target = self
    quitAppButton.action = #selector(SystemSettingViewController.quitApp(_:))

    showNotificationCheckbox.state = Storage.showsNotification.stateValue
  }

  @objc func quitApp(_ sender: AnyObject) {
    NSApplication.shared.terminate(nil)
  }

  @IBAction func showNotification(_ sender: NSButton) {
    Storage.showsNotification = sender.state.boolValue
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
