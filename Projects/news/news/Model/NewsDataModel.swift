//
//  File.swift
//  news
//
//  Created by aayushisingh on 03/11/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import Foundation
class NewsDataModel: Decodable {
    var sourceName: String = ""
    var author: String = ""
    var title: String = ""
    var description: String = ""
    var url: String = ""
    var content: String = ""
    var imageToURL: String = ""
}
