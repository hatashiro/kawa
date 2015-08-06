//
//  HyperlinkTextField.swift
//  kawa
//
//  Created by noraesae on 06/08/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class HyperlinkTextField: NSTextField {
    func setURL(url: NSURL) {
        self.allowsEditingTextAttributes = true
        self.selectable = true
        self.attributedStringValue = linkString(stringValue, url: url)
    }

    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: NSCursor.pointingHandCursor())
    }

    func linkString(text: String, url: NSURL) -> NSMutableAttributedString {
        var attrString = NSMutableAttributedString(string: text)
        var range = NSRange(location: 0, length: attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value: url.absoluteString!, range: range)
        attrString.addAttribute(NSFontAttributeName, value: font!, range: range)
        attrString.addAttribute(NSForegroundColorAttributeName, value: NSColor.blueColor(), range: range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSSingleUnderlineStyle, range: range)
        attrString.endEditing()
        return attrString
    }
}
