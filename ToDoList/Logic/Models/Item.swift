//
//  Item.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
