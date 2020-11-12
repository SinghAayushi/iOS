//
//  TodoListItem.swift
//  TodoApp
//
//  Created by aayushisingh on 30/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import Foundation
import RealmSwift

class TodoListItem : Object {
    @objc dynamic var todoListItem: String = ""
    @objc dynamic var todoItemChecked: Bool = false
    var parent = LinkingObjects(fromType: CategoryList.self, property: "todoListArray")
}
 
