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

    var tisInputSource: TISInputSource? = nil
    var id: String = ""
    var name: String = ""
    var icon: NSImage? = nil

    init(tisInputSource: TISInputSource) {
        self.tisInputSource = tisInputSource
        self.id = InputSource.getProperty(tisInputSource, kTISPropertyInputSourceID)!
        self.name = InputSource.getProperty(tisInputSource, kTISPropertyLocalizedName)!

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
    
    static func tweak() {
        selectPrevious()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(selectPrevious), userInfo: nil, repeats: false)
    }

    @objc
    static func selectPrevious() {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)!

        let down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: true)!
        let up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: false)!

        let flag = CGEventFlags(rawValue: CGEventFlags.maskShift.rawValue | CGEventFlags.maskCommand.rawValue)
        down.flags = flag;
        up.flags = flag;

        let loc = CGEventTapLocation.cghidEventTap

        down.post(tap: loc)
        up.post(tap: loc)
    }
}
