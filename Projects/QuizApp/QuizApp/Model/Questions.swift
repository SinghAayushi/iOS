//
//  Questions.swift
//  QuizApp
//
//  Created by aayushisingh on 04/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import Foundation
class Question{
    let quest: String
    let ans: Bool
    
    init(question: String, answer: Bool) {
        quest = question
        ans = answer
    }
}
