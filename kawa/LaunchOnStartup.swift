import Foundation

class LaunchOnStartup {
    static func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            let loginItems = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as Array

            if loginItems.count == 0 {
                return (nil, kLSSharedFileListItemBeforeFirst.takeRetainedValue())
            }

            let lastItemRef: LSSharedFileListItem = loginItems.last as! LSSharedFileListItem

            for currentItemRef in loginItems as! [LSSharedFileListItem] {
                if let itemUrl = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                    if (itemUrl.takeRetainedValue() as URL) == appUrl {
                        return (currentItemRef, lastItemRef)
                    }
                }
            }

            return (nil, lastItemRef)
        }
        return (nil, nil)
    }

    static func setLaunchAtStartup(_ shouldLaunch: Bool) {
        let itemReferences = itemReferencesInLoginItems()
        let alreadyExists = (itemReferences.existingReference != nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            if !alreadyExists && shouldLaunch {
                let appUrl = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL
                LSSharedFileListInsertItemURL(
                    loginItemsRef,
                    itemReferences.lastReference,
                    nil,
                    nil,
                    appUrl,
                    nil,
                    nil
                )
            } else if alreadyExists && !shouldLaunch {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef, itemRef);
                }
            }
        }
    }
}
