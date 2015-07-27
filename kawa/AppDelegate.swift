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
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        InputSourceManager.initialize()
        showPreferenceWindow()
    }

    func showPreferenceWindow() {
        if preferenceWindowController == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)!
            preferenceWindowController = storyboard.instantiateControllerWithIdentifier("Preference") as! PreferenceWindowController
        }
        preferenceWindowController.showWindow(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
}
