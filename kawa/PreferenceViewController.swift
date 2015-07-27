//
//  PreferenceViewController.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSViewController {
    @IBOutlet weak var tableView: PreferenceTableView!
    
    func loadInputSources() {
        tableView.setDataSource(tableView)
        tableView.setDelegate(tableView)
        tableView.reloadData()
    }
}
