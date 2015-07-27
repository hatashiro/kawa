//
//  PreferenceViewController.swift
//  kawa
//
//  Created by noraesae on 27/07/2015.
//  Copyright (c) 2015 noraesae. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSViewController {
    func loadInputSources() {
        // FIXME
        for i in InputSourceManager.inputSources {
            println(i.id)
            println(i.name)
        }
    }
}
