//
//  InputSourceManager.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Carbon
import Cocoa

class InputSource: Equatable {
    static func getProperty<T>(source: TISInputSource, _ key: CFString) -> T? {
        let cfType = TISGetInputSourceProperty(source, key)
        if (cfType != nil) {
            return Unmanaged<AnyObject>.fromOpaque(COpaquePointer(cfType)).takeUnretainedValue() as? T
        } else {
            return nil
        }
    }

    static func isProperInputSource(source: TISInputSource) -> Bool {
        let category: String = getProperty(source, kTISPropertyInputSourceCategory)!
        let selectable: Bool = getProperty(source, kTISPropertyInputSourceIsSelectCapable)!
        return category == (kTISCategoryKeyboardInputSource as String) && selectable
    }

    var tisInputSource: TISInputSource? = nil
    var id: String = ""
    var name: String = ""
    var icon: NSImage? = nil

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource
        self.id = InputSource.getProperty(tisInputSource, kTISPropertyInputSourceID)!
        self.name = InputSource.getProperty(tisInputSource, kTISPropertyLocalizedName)!

        let imageURL: NSURL? = InputSource.getProperty(tisInputSource, kTISPropertyIconImageURL)
        if imageURL != nil {
            self.icon = NSImage(contentsOfURL: getRetinaImageURL(imageURL!))
            if self.icon == nil {
                self.icon = NSImage(contentsOfURL: getTiffImageURL(imageURL!))
                if self.icon == nil {
                    self.icon = NSImage(contentsOfURL: imageURL!)
                }
            }
        } else {
            let iconRef: IconRef? = COpaquePointer(TISGetInputSourceProperty(tisInputSource, kTISPropertyIconRef))
            if iconRef != nil {
                self.icon = NSImage(iconRef: iconRef!)
            }
        }
    }

    func select() {
        if InputSourceManager.useSimpleSwitchMethod {
            self.selectInputSource()
        } else {
            if let previousInput = InputSourceManager.previousOf(self) {
                previousInput.selectInputSource()
                InputSourceManager.selectNext()
            }
        }
    }

    func selectInputSource() {
        TISSelectInputSource(tisInputSource)
    }

    func getRetinaImageURL(path: NSURL) -> NSURL {
        var components = path.pathComponents!
        let filename: String = components.removeLast() as! String
        let ext: String = path.pathExtension!
        let retinaFilename = filename.stringByReplacingOccurrencesOfString("." + ext, withString: "@2x." + ext)
        return NSURL.fileURLWithPathComponents(components + [retinaFilename])!
    }

    func getTiffImageURL(path: NSURL) -> NSURL {
        return path.URLByDeletingPathExtension!.URLByAppendingPathExtension("tiff")
    }
}

func ==(lhs: InputSource, rhs: InputSource) -> Bool {
    return lhs.id == rhs.id
}

class InputSourceManager {
    static var inputSources: [InputSource] = []
    static var useSimpleSwitchMethod: Bool = Settings.get(Settings.useSimpleSwitchMethod, withDefaultValue: false)

    static func initialize() {
        let arr = TISCreateInputSourceList(nil, 0).takeUnretainedValue() as! [TISInputSource]

        inputSources = arr.filter(InputSource.isProperInputSource)
            .map {
                (var tisInputSource) -> InputSource in
                return InputSource(tisInputSource: tisInputSource)
            }
    }

    static func previousOf(inputSource: InputSource) -> InputSource? {
        if let idx = find(inputSources, inputSource) {
            let previousIdx = idx == 0 ? idx + inputSources.count - 1 : idx - 1
            return inputSources[previousIdx]
        } else {
            return nil
        }
    }

    static func selectNext() {
        let src = CGEventSourceCreate(CGEventSourceStateID(kCGEventSourceStateHIDSystemState)).takeRetainedValue()

        let down = CGEventCreateKeyboardEvent(src, CGKeyCode(kVK_Space), true).takeRetainedValue()
        let up = CGEventCreateKeyboardEvent(src, CGKeyCode(kVK_Space), false).takeRetainedValue()

        let flag = CGEventFlags(kCGEventFlagMaskAlternate) | CGEventFlags(kCGEventFlagMaskCommand)
        CGEventSetFlags(down, flag);
        CGEventSetFlags(up, flag);

        let loc = CGEventTapLocation(kCGHIDEventTap)

        CGEventPost(loc, down)
        CGEventPost(loc, up)
    }
}
