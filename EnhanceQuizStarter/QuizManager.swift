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
    case startGame, playAgain, initialSetup
}

class QuizManager {
    
    // MARK: - Properties
    
    let questionsPerRound = 10
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var quiz = Quiz()
    var chosenQuestions: [Int] = []
    var gameStartSound: SystemSoundID = 0
    var gameCorrectSound: SystemSoundID = 1
    var gameIncorrectSound: SystemSoundID = 2
    var correctAnswer = ""
    var secondsPerRound = 15
    
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
        //Create sound for game starting
        let startSoundPath = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let startSoundUrl = URL(fileURLWithPath: startSoundPath!)
        AudioServicesCreateSystemSoundID(startSoundUrl as CFURL, &gameStartSound)
        
        //Create sound for correct question selection
        let correctSoundPath = Bundle.main.path(forResource: "magicChime", ofType: "wav")
        let correctSoundUrl = URL(fileURLWithPath: correctSoundPath!)
        AudioServicesCreateSystemSoundID(correctSoundUrl as CFURL, &gameCorrectSound)
        //Create sound for incorrect question selection
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
        // Reset everything if it is not already zero and play beginning sound
        questionsAsked = 0
        correctQuestions = 0
        chosenQuestions = []
        playGameStartSound()
    }
    
    func getQuestion() -> Question {
        
        // check to see if this questions index is in the selected question index array
        // If so then pick another question, if not then add that index to the array and pass
        // the question to the caller
        var foundNewQuestion = false
        while foundNewQuestion == false {
            let selectedQuestionIndex = GKRandomSource.sharedRandom().nextInt(upperBound: quiz.questions.count)
            if !chosenQuestions.contains(selectedQuestionIndex) {
                let question = quiz.questions[selectedQuestionIndex]
                chosenQuestions.append(selectedQuestionIndex)
                foundNewQuestion = true
                // Increment the questions asked counter
                questionsAsked += 1
                return question
            }
        }
    }
    
    @objc func checkAnswer(_ answer: String) -> Bool {

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
