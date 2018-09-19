//
//  Question.swift
//  EnhanceQuizStarter
//
//  Created by Joshua Borck on 9/17/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct Question {
    var question: String
    var answers: [String]
    var correctAnswer: String
    
    init(question: String, answers: [String], correctAnswer: String) {
        self.question = question
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}
