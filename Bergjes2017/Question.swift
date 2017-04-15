//
//  Question.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 15/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

class Question: NSObject {
    var questionKey: String!
    var question: String!
    var answerA: String!
    var answerB: String!
    var answerC: String!
    var answerD: String!
    
    init?(questionKey: String, question: String, answerA: String, answerB: String, answerC: String, answerD: String) {
        self.question = question
        self.questionKey = questionKey
        self.answerA = answerA
        self.answerB = answerB
        self.answerC = answerC
        self.answerD = answerD
    }
}
