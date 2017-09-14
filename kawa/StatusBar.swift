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
    static var preferenceWindowController: PreferenceWindowController?
    static let statusBar = NSStatusBar.system()
    static var item: NSStatusItem? = nil

    static func initWithPreferenceWindowController(_ preferenceWindowController: PreferenceWindowController) {
        self.preferenceWindowController = preferenceWindowController

        if Settings.get(.showMenubarIcon, withDefaultValue: true) {
            createStatusBarItem()
        }
    }

    static func createStatusBarItem() {
        if item == nil {
            item = statusBar.statusItem(withLength: -1)

            let button = item!.button!
            button.target = self
            button.action = #selector(StatusBar.action(_:))
            button.image = NSImage(named: "StatusItemIcon")
            button.appearsDisabled = false;
            button.toolTip = "Click to open preferences"
        }
    }

    static func action(_ sender: AnyObject) {
        preferenceWindowController!.showAndActivate(sender)
    }

    static func removeStatusBarItem() {
        if item != nil {
            statusBar.removeStatusItem(item!)
            item = nil
        }
    }
}
