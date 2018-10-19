//
//  PreferenceWindowController.swift
//  kawa
//
//  Created by utatti on 27/07/2015.
//  Copyright (c) 2015-2016 utatti and project contributors.
//  Licensed under the MIT License.
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
        let workspace = NSWorkspace.shared
        workspace.menuBarOwningApplication?.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
    }
}
