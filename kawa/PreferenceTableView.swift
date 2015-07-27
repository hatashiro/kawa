//
//  PreferenceTableView.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class PreferenceTableView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return InputSourceManager.inputSources.count
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: NSTableCellView?

        if tableColumn?.identifier == "Keyboard" {
            cell = tableView.makeViewWithIdentifier("KeyboardCellView", owner: self) as? NSTableCellView

            let inputSource = InputSourceManager.inputSources[row]
            cell!.textField?.stringValue = inputSource.name
            cell!.imageView?.image = inputSource.icon
        }

        return cell
    }
}
