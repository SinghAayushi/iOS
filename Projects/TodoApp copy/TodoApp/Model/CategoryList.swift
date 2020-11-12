//
//  Category.swift
//  TodoApp
//
//  Created by aayushisingh on 30/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryList: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let todoListArray = List<TodoListItem>()
}
