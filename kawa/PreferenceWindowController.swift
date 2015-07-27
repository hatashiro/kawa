//
//  PreferenceWindowController.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()

        let viewController = contentViewController as! PreferenceViewController
        viewController.loadInputSources()
    }

    func showAndFocusWindow(sender: AnyObject?) {
        self.showWindow(sender)
        self.window?.makeKeyAndOrderFront(sender)
        NSApp.activateIgnoringOtherApps(true)
    }

    func hideWindow(sender: AnyObject?) {
        self.window?.orderOut(sender)
    }
}
