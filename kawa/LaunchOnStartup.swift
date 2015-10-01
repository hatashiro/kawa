//
//  LaunchOnStartup.swift
//  kawa
//
//  Created by noraesae on 02/08/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Foundation

class LaunchOnStartup {
    static func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
        let appUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil {
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as Array

            if loginItems.count == 0 {
                return (nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue())
            }

            let lastItemRef: LSSharedFileListItemRef = loginItems.last as! LSSharedFileListItemRef

            for currentItemRef in loginItems as! [LSSharedFileListItemRef] {
                if let itemUrl = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                    if (itemUrl.takeRetainedValue() as NSURL).isEqual(appUrl) {
                        return (currentItemRef, lastItemRef)
                    }
                }
            }

            return (nil, lastItemRef)
        }
        return (nil, nil)
    }

    static func setLaunchAtStartup(shouldLaunch: Bool) {
        let itemReferences = itemReferencesInLoginItems()
        let alreadyExists = (itemReferences.existingReference != nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil {
            if !alreadyExists && shouldLaunch {
                if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        itemReferences.lastReference,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                }
            } else if alreadyExists && !shouldLaunch {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                }
            }
        }
    }
}
