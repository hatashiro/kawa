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
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        InputSourceManager.initialize()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
}
