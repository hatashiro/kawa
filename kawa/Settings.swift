//
//  Settings.swift
//  kawa
//
//  Created by noraesae on 02/08/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class Settings {
    static let defaults = UserDefaults.standard

    static let showMenubarIcon = "show-menubar-icon"
    static let launchOnStartup = "launch-on-startup"
    static let launchedForTheFirstTime = "launched-for-the-first-time"

    static func get<T>(_ key: String, withDefaultValue: T) -> T {
        let val: T? = defaults.object(forKey: key) as? T
        if val != nil {
            return val!
        } else {
            return withDefaultValue
        }
    }

    static func set<T>(_ key: String, toValue: T) {
        defaults.set((toValue as AnyObject), forKey: key)
        defaults.synchronize()
    }
}
