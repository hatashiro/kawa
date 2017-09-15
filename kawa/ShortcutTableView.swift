//
//  ShortcutTableView.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015-2017 noraesae and project contributors.
//  Licensed under the MIT License.
//

import Cocoa

class ShortcutTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return InputSourceManager.inputSources.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = tableColumn?.identifier
        let inputSource = InputSourceManager.inputSources[row]

        if identifier == "Keyboard" {
            return createKeyboardCellView(tableView, inputSource)
        } else if identifier == "Shortcut" {
            return createShorcutCellView(tableView, inputSource)
        }

        return nil
    }

    func createKeyboardCellView(_ tableView: NSTableView, _ inputSource: InputSource) -> NSTableCellView? {
        let cell = tableView.make(withIdentifier: "KeyboardCellView", owner: self) as? NSTableCellView
        cell!.textField?.stringValue = inputSource.name
        cell!.imageView?.image = inputSource.icon
        return cell
    }

    func createShorcutCellView(_ tableView: NSTableView, _ inputSource: InputSource) -> ShortcutCellView? {
        let cell = tableView.make(withIdentifier: "ShortcutCellView", owner: self) as? ShortcutCellView
        cell?.setInputSource(inputSource)
        return cell
    }
}
