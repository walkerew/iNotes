//
//  Note.swift
//  iNotes
//
//  Created by Emily Walker on 12/5/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import Foundation

class Note {
    var title: String?
    var body: String?
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    convenience init(title: String) {
        self.init(title: title, body: "")
    }
    
    convenience init() {
        self.init(title: "Untitled", body: "")
    }
}
