//
//  Item.swift
//  Todoey
//
//  Created by charles.liu on 2017-12-21.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import Foundation

class Item : Codable {
    var title : String = ""
    var done : Bool = false
    
    init(title: String) {
        self.title = title
        self.done = false
    }
}
