//
//  PreferenceWindowController.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController, NSWindowDelegate {
    func showAndActivate(_ sender: AnyObject?) {
        self.showWindow(sender)
        self.window?.makeKeyAndOrderFront(sender)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {
        deactivate()
    }

    func deactivate() {
        // focus an application owning the menu bar
        let workspace = NSWorkspace.shared()
        workspace.menuBarOwningApplication?.activate(options: NSApplicationActivationOptions.activateIgnoringOtherApps)
    }
}
