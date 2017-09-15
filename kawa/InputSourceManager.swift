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
    let isCJK: Bool

    var icon: NSImage? = nil

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource
        id = InputSource.getProperty(tisInputSource, kTISPropertyInputSourceID)!
        name = InputSource.getProperty(tisInputSource, kTISPropertyLocalizedName)!

        let langs: Array<String> = InputSource.getProperty(tisInputSource, kTISPropertyInputSourceLanguages)!
        isCJK = langs.contains(where: { $0 == "ko" || $0 == "ja" || $0.hasPrefix("zh") })

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

        if isCJK {
            // Workaround for TIS CJK layout bug:
            // when it's CJK, select nonCJK input first and then return
            if let nonCJK = InputSourceManager.nonCJKSource() {
                nonCJK.select()
                Thread.sleep(forTimeInterval: 0.05)
                InputSourceManager.selectPrevious()
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
    
    static func nonCJKSource() -> InputSource? {
        return inputSources.first(where: { !$0.isCJK })
    }

    static func selectPrevious() {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)!

        let down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: true)!
        let up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: false)!

        let flag = CGEventFlags(rawValue: CGEventFlags.maskAlternate.rawValue | CGEventFlags.maskCommand.rawValue)
        down.flags = flag;
        up.flags = flag;

        let loc = CGEventTapLocation.cghidEventTap

        down.post(tap: loc)
        up.post(tap: loc)
    }
}
