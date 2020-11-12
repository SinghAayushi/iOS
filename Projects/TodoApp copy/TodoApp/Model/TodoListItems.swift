//
//  File.swift
//  TodoApp
//
//  Created by aayushisingh on 28/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

//import Foundation
//class TodoListItem: NSObject, NSCoding, Encodable, Decodable {
//
//    init(todoListItem: String, todoItemChecked: Bool) {
//        self.todoListItem = todoListItem
//        self.todoItemChecked = todoItemChecked
//    }
//    func encode(with coder: NSCoder) {
//        coder.encode(todoListItem, forKey: "title")
//        coder.encode(todoItemChecked, forKey: "done")
//    }
//
//    required convenience init(coder: NSCoder) {
//        let todoListItemLabel = coder.decodeObject(forKey: "title") as! String
//        let todoIsItemChecked = coder.decodeBool(forKey: "done")
//        self.init(todoListItem: todoListItemLabel, todoItemChecked: todoIsItemChecked)
//    }
//
//    var todoListItem: String = ""
//    var todoItemChecked: Bool =  false
//}
