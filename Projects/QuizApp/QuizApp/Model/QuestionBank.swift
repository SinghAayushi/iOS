//
//  QuestionBank.swift
//  QuizApp
//
//  Created by aayushisingh on 04/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import Foundation
class QuestionBank{
    var list = [Question]()
    init() {
        list.append(Question(question: "a", answer: true))
        list.append(Question(question: "b", answer: true))
        list.append(Question(question: "c", answer: true))
        list.append(Question(question: "d", answer: true))
        list.append(Question(question: "f", answer: false))
        list.append(Question(question: "g", answer: false))
        list.append(Question(question: "h", answer: false))
        list.append(Question(question: "i", answer: true))
    }
}
