//
//  ShortcutViewController.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class ShortcutViewController: NSViewController {
    @IBOutlet weak var tableView: ShortcutTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInputSources()
    }
    
    func loadInputSources() {
        tableView.setDataSource(tableView)
        tableView.setDelegate(tableView)
        tableView.reloadData()
    }
}
