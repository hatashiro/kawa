//
//  ShortcutTableView.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class ShortcutTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return InputSourceManager.inputSources.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier
        let inputSource = InputSourceManager.inputSources[row]

        if identifier == "Keyboard" {
            return createKeyboardCellView(tableView, inputSource)
        } else if identifier == "Shortcut" {
            return createShorcutCellView(tableView, inputSource)
        }

        return nil
    }

    func createKeyboardCellView(tableView: NSTableView, _ inputSource: InputSource) -> NSTableCellView? {
        var cell = tableView.makeViewWithIdentifier("KeyboardCellView", owner: self) as? NSTableCellView
        cell!.textField?.stringValue = inputSource.name
        cell!.imageView?.image = inputSource.icon
        return cell
    }

    func createShorcutCellView(tableView: NSTableView, _ inputSource: InputSource) -> ShortcutCellView? {
        var cell = tableView.makeViewWithIdentifier("ShortcutCellView", owner: self) as? ShortcutCellView
        cell?.setInputSource(inputSource)
        return cell
    }
}
