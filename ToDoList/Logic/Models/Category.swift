//
//  Category.swift
//  ToDoList
//
//  Created by Bunyk Jaroslav on 2/5/18.
//  Copyright © 2018 JaroslavBunyk. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
