//
//  InputSourceManager.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015-2017 noraesae and project contributors.
//  Licensed under the MIT License.
//

import Carbon
import Cocoa

class InputSource: Equatable {
    static func getProperty<T>(_ source: TISInputSource, _ key: CFString) -> T? {
        let cfType = TISGetInputSourceProperty(source, key)
        if (cfType != nil) {
            return Unmanaged<AnyObject>.fromOpaque(cfType!).takeUnretainedValue() as? T
        } else {
            return nil
        }
    }

    static func isProperInputSource(_ source: TISInputSource) -> Bool {
        let category: String = getProperty(source, kTISPropertyInputSourceCategory)!
        let selectable: Bool = getProperty(source, kTISPropertyInputSourceIsSelectCapable)!
        return category == (kTISCategoryKeyboardInputSource as String) && selectable
    }

    let tisInputSource: TISInputSource
    let id: String
    let name: String
    let isCJKV: Bool

    var icon: NSImage? = nil

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource
        id = InputSource.getProperty(tisInputSource, kTISPropertyInputSourceID)!
        name = InputSource.getProperty(tisInputSource, kTISPropertyLocalizedName)!

        let lang = (
            InputSource.getProperty(tisInputSource, kTISPropertyInputSourceLanguages)!
                as Array<String>
        )[0]
        isCJKV = lang == "ko" || lang == "ja" || lang == "vi" || lang.hasPrefix("zh")

        let imageURL: URL? = InputSource.getProperty(tisInputSource, kTISPropertyIconImageURL)
        if imageURL != nil {
            self.icon = NSImage(contentsOf: getRetinaImageURL(imageURL!))
            if self.icon == nil {
                self.icon = NSImage(contentsOf: getTiffImageURL(imageURL!))
                if self.icon == nil {
                    self.icon = NSImage(contentsOf: imageURL!)
                }
            }
        } else {
            let iconRef: IconRef? = OpaquePointer(TISGetInputSourceProperty(tisInputSource, kTISPropertyIconRef))
            if iconRef != nil {
                self.icon = NSImage(iconRef: iconRef!)
            }
        }
    }

    func select() {
        TISSelectInputSource(tisInputSource)

        if isCJKV, let selectPreviousShortcut = InputSourceManager.getSelectPreviousShortcut() {
            // Workaround for TIS CJKV layout bug:
            // when it's CJKV, select nonCJKV input first and then return
            if let nonCJKV = InputSourceManager.nonCJKVSource() {
                nonCJKV.select()
                InputSourceManager.selectPrevious(shortcut: selectPreviousShortcut)
            }
        }
    }

    func getRetinaImageURL(_ path: URL) -> URL {
        var components = path.pathComponents
        let filename: String = components.removeLast()
        let ext: String = path.pathExtension
        let retinaFilename = filename.replacingOccurrences(of: "." + ext, with: "@2x." + ext)
        return NSURL.fileURL(withPathComponents: components + [retinaFilename])!
    }

    func getTiffImageURL(_ path: URL) -> URL {
        return path.deletingPathExtension().appendingPathExtension("tiff")
    }
}

func ==(lhs: InputSource, rhs: InputSource) -> Bool {
    return lhs.id == rhs.id
}

class InputSourceManager {
    static var inputSources: [InputSource] = []

    static func initialize() {
        let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        let inputSourceList = inputSourceNSArray as! [TISInputSource]

        inputSources = inputSourceList.filter(InputSource.isProperInputSource)
            .map {
                (tisInputSource) -> InputSource in
                return InputSource(tisInputSource: tisInputSource)
            }
    }
    
    static func nonCJKVSource() -> InputSource? {
        return inputSources.first(where: { !$0.isCJKV })
    }

    static func selectPrevious(shortcut: (Int, UInt64)) {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)!

        let rawKey = shortcut.0
        let rawFlags = shortcut.1

        let down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(rawKey), keyDown: true)!
        let up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(rawKey), keyDown: false)!

        let flag = CGEventFlags(rawValue: rawFlags)
        down.flags = flag;
        up.flags = flag;

        let loc = CGEventTapLocation.cghidEventTap

        down.post(tap: loc)
        up.post(tap: loc)
    }

    // from read-symbolichotkeys script of Karabiner
    // github.com/tekezo/Karabiner/blob/master/src/util/read-symbolichotkeys/read-symbolichotkeys/main.m
    static func getSelectPreviousShortcut() -> (Int, UInt64)? {
        guard let dict = UserDefaults.standard.persistentDomain(forName: "com.apple.symbolichotkeys") else {
            return nil
        }
        guard let symbolichotkeys = dict["AppleSymbolicHotKeys"] as! NSDictionary? else {
            return nil
        }
        guard let symbolichotkey = symbolichotkeys["60"] as! NSDictionary? else {
            return nil
        }
        if (symbolichotkey["enabled"] as! NSNumber).intValue != 1 {
            return nil
        }
        guard let value = symbolichotkey["value"] as! NSDictionary? else {
            return nil
        }
        guard let parameters = value["parameters"] as! NSArray? else {
            return nil
        }
        return (
            (parameters[1] as! NSNumber).intValue,
            (parameters[2] as! NSNumber).uint64Value
        )
    }
}
