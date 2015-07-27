//
//  StatusBar.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import AppKit
import Cocoa

class StatusBar: NSObject {
    var preferenceWindowController: PreferenceWindowController!
    var item: NSStatusItem!

    init(preferenceWindowController: PreferenceWindowController) {
        super.init()

        self.preferenceWindowController = preferenceWindowController
        
        let bar = NSStatusBar.systemStatusBar()
        item = bar.statusItemWithLength(48)

        let button = item.button!
        button.title = "Kawa"
        button.target = self
        button.action = Selector("action:")
    }

    func action(sender: AnyObject) {
        preferenceWindowController.showAndFocusWindow(sender)
    }
}
