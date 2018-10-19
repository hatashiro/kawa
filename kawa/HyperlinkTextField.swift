//
//  HyperlinkTextField.swift
//  kawa
//
//  Created by utatti on 06/08/2015.
//  Copyright (c) 2015-2016 utatti and project contributors.
//  Licensed under the MIT License.
//

import Cocoa

class HyperlinkTextField: NSTextField {
    func setURL(_ url: URL) {
        self.allowsEditingTextAttributes = true
        self.isSelectable = true
        self.attributedStringValue = linkString(stringValue, url: url)
    }

    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
    }

    func linkString(_ text: String, url: URL) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSAttributedString.Key.link, value: url.absoluteString, range: range)
        attrString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.blue, range: range)
        attrString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue as AnyObject, range: range)
        attrString.endEditing()
        return attrString
    }
}
