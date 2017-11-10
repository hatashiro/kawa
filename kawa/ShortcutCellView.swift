//
//  ShortcutCellView.swift
//  kawa
//
//  Created by utatti on 29/07/2015.
//  Copyright (c) 2015-2017 utatti and project contributors.
//  Licensed under the MIT License.
//

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
        showNotification(inputSource.name, icon: inputSource.icon)
    }

    func showNotification(_ message: String, icon: NSImage?) {
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        guard Settings.get(.showNotification, withDefaultValue: true) else { return }
        let notification = NSUserNotification()
        notification.informativeText = message
        notification.contentImage = icon
        NSUserNotificationCenter.default.deliver(notification)
    }
}
