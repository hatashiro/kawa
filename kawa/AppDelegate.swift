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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        InputSourceManager.initialize()
        showPreferenceWindow()
        StatusBar.initWithPreferenceWindowController(preferenceWindowController)
    }

    func showPreferenceWindow() {
        if preferenceWindowController == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)!
            preferenceWindowController = storyboard.instantiateControllerWithIdentifier("Preference") as! PreferenceWindowController
        }
        preferenceWindowController.showAndActivate(self)
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        preferenceWindowController.showAndActivate(self)
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
