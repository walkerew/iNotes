//
//  Notebook.swift
//  iNotes
//
//  Created by Emily Walker on 12/8/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import Foundation

class Notebook {
    var title: String?
    var notesArray: [Note] = []
    
    init(title: String, notesArray: [Note]) {
        self.title = title
        self.notesArray = notesArray
    }
    
    convenience init(title: String) {
        self.init(title: title, notesArray: [])
    }
    
}
