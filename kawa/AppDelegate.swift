//
//  AppDelegate.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferenceWindowController: PreferenceWindowController!
    var justLaunched: Bool = true
    var launchedForTheFirstTime: Bool = Settings.get(Settings.launchedForTheFirstTime, withDefaultValue: true)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        InputSourceManager.initialize()
        preferenceWindowController = instantiatePreferenceWindowController()
        StatusBar.initWithPreferenceWindowController(preferenceWindowController)
        LaunchOnStartup.setLaunchAtStartup(Settings.get(Settings.launchOnStartup, withDefaultValue: true))

        if launchedForTheFirstTime {
            Settings.set(Settings.launchedForTheFirstTime, toValue: false)
        }
    }

    func instantiatePreferenceWindowController() -> PreferenceWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateControllerWithIdentifier("Preference") as! PreferenceWindowController
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        if !justLaunched || launchedForTheFirstTime {
            preferenceWindowController.showAndActivate(self)
        }
        
        if justLaunched {
            justLaunched = false
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    @IBAction func showPreferences(sender: AnyObject?) {
        preferenceWindowController.showAndActivate(self)
    }

    @IBAction func hidePreferences(sender: AnyObject?) {
        preferenceWindowController.close()
    }
}
