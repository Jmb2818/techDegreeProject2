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

enum QuizSection {
    case startRegular, startLightning, playAgain
}

class QuizManager {
    
    // MARK: - Properties
    
    let questionsPerRound = 2
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var quiz = Quiz()
    var chosenQuestions: [Int] = []
    var gameStartSound: SystemSoundID = 0
    var gameCorrectSound: SystemSoundID = 1
    var gameIncorrectSound: SystemSoundID = 2
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
            quiz.questions.shuffle()
        }
    }
    
    convenience init() {
        self.init(dictionary: questionDictionary)
    }
    
    // MARK: - Functions
    
    func loadGameStartSound() {
        let startSoundPath = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let startSoundUrl = URL(fileURLWithPath: startSoundPath!)
        AudioServicesCreateSystemSoundID(startSoundUrl as CFURL, &gameStartSound)
        
        let correctSoundPath = Bundle.main.path(forResource: "magicChime", ofType: "wav")
        let correctSoundUrl = URL(fileURLWithPath: correctSoundPath!)
        AudioServicesCreateSystemSoundID(correctSoundUrl as CFURL, &gameCorrectSound)
        
        let incorrectSoundPath = Bundle.main.path(forResource: "metalTwing", ofType: "wav")
        let incorrectSoundUrl = URL(fileURLWithPath: incorrectSoundPath!)
        AudioServicesCreateSystemSoundID(incorrectSoundUrl as CFURL, &gameIncorrectSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameStartSound)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(gameCorrectSound)
    }
    func playIncorrectAnswerSound() {
        AudioServicesPlaySystemSound(gameIncorrectSound)
    }
    
    func startGame() {
        questionsAsked = 0
        correctQuestions = 0
        chosenQuestions = []
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
            playCorrectAnswerSound()
            return true
        } else {
            playIncorrectAnswerSound()
            return false
        }
    }
    
}




let questionDictionary = [
    [
        "question" : "In an entire lifetime, the average person walks the equivalent of how many times around the world?",
        "answers" : ["Four", "Ten", "Five"],
        "correctAnswer" : "Five"
    ],
    [
        "question" : "What color is oxygen when it is not a gas?",
        "answers" : ["Brown","Pale Green", "Light Blue", "Hot Pink"],
        "correctAnswer" : "Light Blue"
    ],
    [
        "question" : "How does it take one blood cell to circulate the whole body one time?",
        "answers" : ["25 Seconds","60 Seconds", "2 Minutes", "5 Minutes"],
        "correctAnswer" : "60 Seconds"
    ],
    [
        "question" : "How many bones in the human body?",
        "answers" : ["300","187", "265", "206"],
        "correctAnswer" : "206"
    ],
    [
        "question" : "How often does your skin replace itself in an average lifetime??",
        "answers" : ["50 Times","900 Times", "2 Million Times", "200 Times"],
        "correctAnswer" : "900 Times"
    ],
    [
        "question" : "Which planet has the most moons?",
        "answers" : ["Pluto","Mars", "Jupiter", "Saturn"],
        "correctAnswer" : "Jupiter"
    ],
    [
        "question" : "If you mix all light colours, what color do you get?",
        "answers" : ["Black","White", "Rainbow", "Purple"],
        "correctAnswer" : "White"
    ],
    [
        "question" : "What survives impacting Earth’s surface?",
        "answers" : ["Meteor","Meteorite", "Asteroid"],
        "correctAnswer" : "Meteorite"
    ],
    [
        "question" : "Which planet is the fastest?",
        "answers" : ["Jupiter","Venus", "Mercury", "Uranus"],
        "correctAnswer" : "Jupiter"
    ]
]
