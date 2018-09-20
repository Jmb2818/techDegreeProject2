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

enum Keys: String {
    case question, answers, correctAnswer
}

class QuizManager {
    
    // MARK: - Properties
    
    let questionsPerRound = 2
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var quiz = Quiz()
    var chosenQuestions: [Int] = []
    var gameSound: SystemSoundID = 0
    var correctAnswer = ""
    
    // MARK: Initializers
    
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
    
    // MARK: - Functions
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func startGame() {
        loadGameStartSound()
        playGameStartSound()
    }
    
    func getQuestion() -> Question {
        var foundNewQuestion = false
        while foundNewQuestion == false {
            let selectedQuestionIndex = GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count)
            if !chosenQuestions.contains(selectedQuestionIndex) {
                let question = quiz.questions[selectedQuestionIndex]
                chosenQuestions.append(selectedQuestionIndex)
                foundNewQuestion = true
                return question
            }
        }
    }
    
    @objc func checkAnswer(_ answer: String) -> Bool {
        // Increment the questions asked counter
        questionsAsked += 1
        if answer == correctAnswer {
            correctQuestions += 1
            return true
        } else {
            return false
        }
    }
    
    func resetGame() {
        questionsAsked = 0
        correctQuestions = 0
        chosenQuestions = []
    }
    
}




let questionDictionary = [
    [
        "question" : "What house did Harry tell the hat he did not want to be in?",
        "answers" : ["Ravenclaw","Slytherin", "Gryffindor", "Hufflepuff"],
        "correctAnswer" : "Slytherin"
    ],
    [
        "question" : "What did the Weasley Twins try to send Harry as a get well present at the end of The Sorcerer's Stone?",
        "answers" : ["A deck of cards","Bertie Bots", "A toilet seat", "A hinkypunk"],
        "correctAnswer" : "A toilet seat"
    ],
    [
        "question" : "Who hand made socks for Harry for Christmas?",
        "answers" : ["Mrs. Weasley","Dobby", "Hermione", "Professor Mcgonagall"],
        "correctAnswer" : "Dobby"
    ],
    [
        "question" : "Who has an otter patronous?",
        "answers" : ["Kingsley Shacklebolt","Harry Potter", "Luna Lovegood", "Neville Longbottom"],
        "correctAnswer" : "Kingsley Shacklebolt"
    ],
    [
        "question" : "Who did Harry pretend to be when first getting on the Kinght's Bus?",
        "answers" : ["Ron Weasley","Neville Longbottom", "Draco Malfoy", "Oliver Wood"],
        "correctAnswer" : "Neville Longbottom"
    ]
]
