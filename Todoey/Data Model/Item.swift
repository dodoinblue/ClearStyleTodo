//
//  Item.swift
//  Todoey
//
//  Created by charles.liu on 2017-12-28.
//  Copyright © 2017 Charles Liu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
