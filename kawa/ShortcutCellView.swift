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

    func setInputSource(inputSource: InputSource) {
        self.inputSource = inputSource
        shortcutKey = inputSource.id.stringByReplacingOccurrencesOfString(".", withString: "-")
        shortcutView.associatedUserDefaultsKey = shortcutKey!
        shortcutView.shortcutValueChange = self.shortcutValueDidChanged
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(shortcutKey!, toAction: selectInput)
    }

    func shortcutValueDidChanged(sender: MASShortcutView!) {
        if sender.shortcutValue == nil {
            resetShortcutBinder()
        }
    }

    func resetShortcutBinder() {
        MASShortcutBinder.sharedBinder().breakBindingWithDefaultsKey(shortcutKey!)
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey(shortcutKey!, toAction: selectInput)
    }

    func selectInput() {
        inputSource?.select()
    }
}
