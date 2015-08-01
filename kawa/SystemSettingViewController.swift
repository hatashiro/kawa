//
//  SystemSettingViewController.swift
//  kawa
//
//  Created by noraesae on 01/08/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class SystemSettingViewController: NSViewController {
    @IBOutlet var quitAppButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        quitAppButton.target = self
        quitAppButton.action = Selector("quitApp:")
    }

    func quitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }
}
