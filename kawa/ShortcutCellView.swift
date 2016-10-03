//
//  ShortcutCellView.swift
//  kawa
//
//  Created by noraesae on 29/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
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
        shortcutView.shortcutValueChange = self.shortcutValueDidChanged
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: shortcutKey!, toAction: selectInput)
    }

    func shortcutValueDidChanged(_ sender: MASShortcutView!) {
        if sender.shortcutValue == nil {
            resetShortcutBinder()
        }
    }

    func resetShortcutBinder() {
        MASShortcutBinder.shared().breakBinding(withDefaultsKey: shortcutKey!)
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: shortcutKey!, toAction: selectInput)
    }

    func selectInput() {
        inputSource?.select()
    }
}
