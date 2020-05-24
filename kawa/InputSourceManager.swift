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
        if isCJKV {
            // Workaround for TIS CJKV layout bug:
            // when it's CJKV, select nonCJKV input twice with delay and then select target
            if let nonCJKV = InputSourceManager.nonCJKVSource() {
                nonCJKV.select()
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
                    nonCJKV.select()
                }
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                    TISSelectInputSource(self.tisInputSource)
                }
            }
        } else {
            TISSelectInputSource(tisInputSource)
        }
    }
}

class InputSourceManager {
    static var inputSources: [InputSource] = []

    static func initialize() {
        let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        let inputSourceList = inputSourceNSArray as! [TISInputSource]

        inputSources = inputSourceList.filter({
            $0.category == TISInputSource.Category.keyboardInputSource && $0.isSelectable
        }).map { InputSource(tisInputSource: $0) }
    }
    
    static func nonCJKVSource() -> InputSource? {
        return inputSources.first(where: { !$0.isCJKV })
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
