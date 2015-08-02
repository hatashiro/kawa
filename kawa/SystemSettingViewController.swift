//
//  SystemSettingViewController.swift
//  kawa
//
//  Created by noraesae on 01/08/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class SystemSettingViewController: NSViewController {
    @IBOutlet var showMenubarIconCheckbox: NSButton!
    @IBOutlet var launchOnStartupCheckbox: NSButton!
    @IBOutlet var quitAppButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        quitAppButton.target = self
        quitAppButton.action = Selector("quitApp:")

        showMenubarIconCheckbox.target = self
        showMenubarIconCheckbox.action = Selector("setShowMenubarIcon:")
        var isOn: Bool = Settings.get(Settings.showMenubarIcon, withDefaultValue: true)
        showMenubarIconCheckbox.state = isOn ? NSOnState : NSOffState

        launchOnStartupCheckbox.target = self
        launchOnStartupCheckbox.action = Selector("setLaunchOnStartup:")
        isOn = Settings.get(Settings.launchOnStartup, withDefaultValue: true)
        launchOnStartupCheckbox.state = isOn ? NSOnState: NSOffState
    }

    func quitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }

    func setShowMenubarIcon(sender: AnyObject) {
        let isOn: Bool = showMenubarIconCheckbox.state == NSOnState
        Settings.set(Settings.showMenubarIcon, toValue: isOn)

        if isOn {
            StatusBar.createStatusBarItem()
        } else {
            StatusBar.removeStatusBarItem()
        }
    }

    func setLaunchOnStartup(sender: AnyObject) {
        let isOn: Bool = launchOnStartupCheckbox.state == NSOnState
        Settings.set(Settings.launchOnStartup, toValue: isOn)
        LaunchOnStartup.setLaunchAtStartup(isOn)
    }
}
