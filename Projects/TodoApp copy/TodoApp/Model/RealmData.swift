//
//  Data.swift
//  TodoApp
//
//  Created by aayushisingh on 30/10/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit
import RealmSwift
class RealmData : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
