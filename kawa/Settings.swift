//
//  Settings.swift
//  kawa
//
//  Created by utatti on 02/08/2015.
//  Copyright (c) 2015-2017 utatti and project contributors.
//  Licensed under the MIT License.
//

import Cocoa

class Settings {
    static let defaults = UserDefaults.standard

    enum Setting: String {
        case showMenubarIcon = "show-menubar-icon"
        case launchOnStartup = "launch-on-startup"
        case showNotification = "show-notification"
        case launchedForTheFirstTime = "launched-for-the-first-time"
    }

    static func get<T>(_ key: Setting, withDefaultValue: T) -> T {
        let val: T? = defaults.object(forKey: key.rawValue) as? T
        if val != nil {
            return val!
        } else {
            return withDefaultValue
        }
    }

    static func set<T>(_ key: Setting, toValue: T) {
        defaults.set((toValue as AnyObject), forKey: key.rawValue)
        defaults.synchronize()
    }
}
