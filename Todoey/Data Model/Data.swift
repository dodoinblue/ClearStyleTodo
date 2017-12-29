//
//  Data.swift
//  Todoey
//
//  Created by charles.liu on 2017-12-28.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age: Int = 0
}
