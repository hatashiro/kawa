//
//  InputSourceManager.swift
//  kawa
//
//  Created by utatti on 27/07/2015.
//  Copyright (c) 2015-2017 utatti and project contributors.
//  Licensed under the MIT License.
//

import Carbon
import Cocoa

class InputSource: Equatable {
    static func == (lhs: InputSource, rhs: InputSource) -> Bool {
        return lhs.id == rhs.id
    }

    let tisInputSource: TISInputSource
    let icon: NSImage?

    var id: String {
        return tisInputSource.id
    }

    var name: String {
        return tisInputSource.name
    }

    var isCJKV: Bool {
        if let lang = tisInputSource.sourceLanguages.first {
            return lang == "ko" || lang == "ja" || lang == "vi" || lang.hasPrefix("zh")
        }
        return false
    }

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource

        var iconImage: NSImage? = nil

        if let imageURL = tisInputSource.iconImageURL {
            for url in [imageURL.retinaImageURL, imageURL.tiffImageURL, imageURL] {
                if let image = NSImage(contentsOf: url) {
                    iconImage = image
                    break
                }
            }
        }

        if iconImage == nil, let iconRef = tisInputSource.iconRef {
            iconImage = NSImage(iconRef: iconRef)
        }

        self.icon = iconImage
    }

    func select() {
        if !isCJKV {
            TISSelectInputSource(tisInputSource)
        } else if let selectNextShortcut = InputSourceManager.getSelectNextShortcut() {
            let distance = InputSourceManager.getDistance(target: self)
            for _ in 0..<distance {
                InputSourceManager.selectNext(shortcut: selectNextShortcut)
            }
            InputSourceManager.lastSelectedInputMethod = self
        }
    }
}

class InputSourceManager {
    static var inputSources: [InputSource] = []
    static var lastSelectedInputMethod: InputSource? = nil
    static var lastSelectTime: Date = Date(timeIntervalSince1970: 0)

    static func initialize() {
        let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        let inputSourceList = inputSourceNSArray as! [TISInputSource]

        inputSources = inputSourceList.filter({
            $0.category == TISInputSource.Category.keyboardInputSource && $0.isSelectable
        }).map { InputSource(tisInputSource: $0) }
    }

    static func currentSource() -> InputSource {
        // the result from macOS is not accurate if being called for multiple times in a short time
        if Date().timeIntervalSince(self.lastSelectTime) < 2 && self.lastSelectedInputMethod != nil {
            return self.lastSelectedInputMethod!
        } else {
            return InputSource(tisInputSource: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
        }
    }

    static func getDistance(target: InputSource) -> Int {
        let currentId = currentSource().id
        let currentIndex = self.inputSources.index(where: {$0.id == currentId})!
        let targetIndex = self.inputSources.index(where: {$0.id == target.id})!
        if (targetIndex > currentIndex) {
            return targetIndex -  currentIndex
        } else {
            return self.inputSources.count - currentIndex + targetIndex
        }
    }

    static func selectNext(shortcut: (Int, UInt64)) {
        self.lastSelectTime = Date()

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
    static func getSelectNextShortcut() -> (Int, UInt64)? {
        guard let dict = UserDefaults.standard.persistentDomain(forName: "com.apple.symbolichotkeys") else {
            return nil
        }
        guard let symbolichotkeys = dict["AppleSymbolicHotKeys"] as! NSDictionary? else {
            return nil
        }
        guard let symbolichotkey = symbolichotkeys["61"] as! NSDictionary? else {
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

private extension URL {
    var retinaImageURL: URL {
        var components = pathComponents
        let filename: String = components.removeLast()
        let ext: String = pathExtension
        let retinaFilename = filename.replacingOccurrences(of: "." + ext, with: "@2x." + ext)
        return NSURL.fileURL(withPathComponents: components + [retinaFilename])!
    }

    var tiffImageURL: URL {
        return deletingPathExtension().appendingPathExtension("tiff")
    }
}
