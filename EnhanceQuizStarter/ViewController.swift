//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    // TODO: Move these to something like UserStrings
    var quizManager = QuizManager()
    private var playAgainArray = ["Play Again"]
    private var initialSetupArray = ["Normal Mode", "Lightning Mode"]
    private var quizWelcome = "Welcome to Quizzer. This is a fun quiz game centered around 15 science facts. Please choose how you would like to play the game. Normal Mode has no time limit. Lightning mode is limited to 15 seconds per question."
    private var welcomeBack = "Welcome Back"
    private var normalModeName = "Normal Mode"
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialSetup(title: quizWelcome)
//        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func displayQuestion() {
        let question = quizManager.getQuestion()
        questionField.text = question.question
        let questionArray = question.answers.shuffled()
        layoutButtons(with: questionArray, into: stackView, for: .startRegular)
        
        //TODO: Move this to quizmanager at the end of the getQuestion()
        quizManager.correctAnswer = question.correctAnswer
    }
    
    func displayScore() {
        // Display play again button
        layoutButtons(with: playAgainArray, into: stackView, for: .playAgain)
        
        questionField.text = "Way to go!\nYou got \(quizManager.correctQuestions) out of \(quizManager.questionsPerRound) correct!"
    }
    
    func initialSetup(title: String) {
        // load everything up
        quizManager.loadGameStartSound()
        quizManager.startGame()
        // Display initial buttons to start game in specific round type
        layoutButtons(with: initialSetupArray, into: stackView, for: .initialSetup)
        questionField.text = title
    }
    
    func nextRound() {
        if quizManager.questionsAsked == quizManager.questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    private func layoutButtons(with array: [String], into stackView: UIStackView, for section: QuizSection) {
        // Remove any buttons that may already be in the stack view from the last round
        if !stackView.subviews.isEmpty {
            for view in stackView.subviews {
                view.removeFromSuperview()
            }
        }
        // For each answer add a button, if play again button then only present that button based on what
        // section of the quiz we are in
        for answer in array {
            switch section {
            case .startRegular:
                let button = GameButton(title: answer, view: stackView)
                button.addTarget(self, action: #selector(verifyAnswer), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            case .startLightning:
                break
            case .playAgain:
                let button = GameButton(title: answer, view: stackView)
                button.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            case .initialSetup:
                let button = GameButton(title: answer, view: stackView)
                if answer == normalModeName {
                    button.addTarget(self, action: #selector(normalMode), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(lightningMode), for: .touchUpInside)
                }
                stackView.addArrangedSubview(button)
                
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func verifyAnswer(_ sender: UIButton) {
        guard let selectedAnswer = sender.currentTitle else {
            fatalError()
        }
        
        if quizManager.checkAnswer(selectedAnswer) {
            
            questionField.text = "Correct!"
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            questionField.text = """
            Sorry, wrong answer!
            The correct answer is \(quizManager.correctAnswer).
            """
            sender.backgroundColor = #colorLiteral(red: 0.7179965102, green: 0.194347001, blue: 0.2058225411, alpha: 1)
            for view in stackView.subviews {
                if let button = view as? UIButton {
                    if button.currentTitle == quizManager.correctAnswer {
                        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }
                }
            }
        }
        
        loadNextRound(delay: 2)
    }
    
    @objc func lightningMode() {
    
    }
    
    @objc func normalMode() {
        nextRound()
    }
    
    @objc func playAgain() {
        initialSetup(title: welcomeBack)
    }
}

