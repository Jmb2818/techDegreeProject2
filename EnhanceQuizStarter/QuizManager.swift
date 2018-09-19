//
//  QuizManager.swift
//  EnhanceQuizStarter
//
//  Created by Joshua Borck on 9/17/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class QuizManager {
    
    // MARK: - Properties
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var quiz = Quiz()
    var gameSound: SystemSoundID = 0
    
    init(dictionary: [[String: Any]]) {
        for questionItem in dictionary {
            guard let questionAsked = questionItem[Keys.question.rawValue] as? String,
                let answers = questionItem[Keys.answers.rawValue] as? [String],
                let correctAnswer = questionItem[Keys.correctAnswer.rawValue] as? String
                else {
                    fatalError("Unable to create questions")
            }
            let question = Question(question: questionAsked, answers: answers, correctAnswer: correctAnswer)
            quiz.questions.append(question)
        }
    }
    
    convenience init() {
        self.init(dictionary: questionDictionary)
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
}




let questionDictionary = [
    [
        "question" : "What house did Harry tell the hat he did not want to be in?",
        "answers" : ["Ravenclaw","Slytherin", "Gryffindor", "Hufflepuff"],
        "answer" : "Slytherin"
    ],
    [
        "question" : "Wha did the Weasley Twins try to send Harry as a get well present at the end of The Sorcerer's Stone?",
        "answers" : ["A deck of cards","Bertie Bots", "A toilet seat", "A hinkypunk"],
        "answer" : "A toilet seat"
    ]
]
