//
//  UserStrings.swift
//  EnhanceQuizStarter
//
//  Created by Joshua Borck on 9/24/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

// A class to hold all the strings used throughout the app to help with safety and mistakes

class UserStrings {
    
    enum General {
        static let playAgainArray = ["Play Again"]
        static let initialSetupArray = ["Normal Mode", "Lightning Mode"]
        static let quizWelcome = "Welcome to Quizzer. Choose a mode."
        static let playAgainSelect = "Choose a mode"
        static let normalModeName = "Normal Mode"
        static let lightningModeInfo = "Lightning mode is limited to 15 seconds per question."
        static let nextQuestion = "Next Question"
        static let correctAnswer = "Correct!"
        static let incorrectAnswer = "Sorry, that's not it."
    }
}
