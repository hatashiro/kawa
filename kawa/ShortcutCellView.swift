import Cocoa

class ShortcutCellView: NSTableCellView {
  @IBOutlet weak var shortcutView: MASShortcutView!

  var inputSource: InputSource?
  var shortcutKey: String?

  func setInputSource(_ inputSource: InputSource) {
    self.inputSource = inputSource
    shortcutKey = inputSource.id.replacingOccurrences(of: ".", with: "-")
    shortcutView.associatedUserDefaultsKey = shortcutKey!
    shortcutView.shortcutValueChange = self.shortcutValueDidChange
    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: shortcutKey!, toAction: selectInput)
  }

  func shortcutValueDidChange(_ sender: MASShortcutView?) {
    if sender?.shortcutValue == nil {
      resetShortcutBinder()
    }
  }

  func resetShortcutBinder() {
    MASShortcutBinder.shared().breakBinding(withDefaultsKey: shortcutKey!)
    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: shortcutKey!, toAction: selectInput)
  }

  func selectInput() {
    guard let inputSource = inputSource else { return }

    inputSource.select()

    if Storage.showsNotification {
      showNotification(inputSource.name, icon: inputSource.icon)
    }
  }

  func showNotification(_ message: String, icon: NSImage?) {
    NSUserNotificationCenter.default.removeAllDeliveredNotifications()
    let notification = NSUserNotification()
    notification.informativeText = message
    notification.contentImage = icon
    NSUserNotificationCenter.default.deliver(notification)
  }
}
