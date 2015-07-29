//
//  ShortcutCellView.swift
//  kawa
//
//  Created by noraesae on 29/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class ShortcutCellView: NSTableCellView {
    @IBOutlet weak var shortcutView: MASShortcutView!

    var inputSource: InputSource?

    func setInputSource(inputSource: InputSource) {
        self.inputSource = inputSource
    }
}
