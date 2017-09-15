//
//  HyperlinkTextField.swift
//  kawa
//
//  Created by noraesae on 06/08/2015.
//  Copyright (c) 2015-2016 noraesae and project contributors.
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
        self.addCursorRect(self.bounds, cursor: NSCursor.pointingHand())
    }

    func linkString(_ text: String, url: URL) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value: url.absoluteString, range: range)
        attrString.addAttribute(NSFontAttributeName, value: font!, range: range)
        attrString.addAttribute(NSForegroundColorAttributeName, value: NSColor.blue, range: range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue as AnyObject, range: range)
        attrString.endEditing()
        return attrString
    }
}
