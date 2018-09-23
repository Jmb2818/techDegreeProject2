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
    var quizManager = QuizManager()
    // TODO: Move these to something like UserStrings
    private var playAgainArray = ["Play Again"]
    private var initialSetupArray = ["Normal Mode", "Lightning Mode"]
    private var quizWelcome = "Welcome to Quizzer. Choose a mode. Lightning mode is limited to 15 seconds per question."
    private var welcomeBack = "Welcome Back"
    private var normalModeName = "Normal Mode"
    var timer = Timer()
    var countdownTimer = Timer()
    var countdownSeconds = 15
    var isLightningModeOn = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var questionCorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialSetup(title: quizWelcome)
    }
    
    // MARK: - Helpers
    
    func displayQuestion(for section: QuizSection) {
        let question = quizManager.getQuestion()
        questionField.text = question.question
        let questionArray = question.answers.shuffled()
        layoutButtons(with: questionArray, into: stackView, for: section)
        
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
        countdownTimerLabel.isHidden = true
        questionCorrectLabel.isHidden = true
    }
    
    @objc func nextRound() {
        beginRound()
        if quizManager.questionsAsked == quizManager.questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Check if lightnining mode is on and if so then start the timer
            if isLightningModeOn {
                countdownTimerLabel.isHidden = false
                runTimer()
                displayQuestion(for: .startGame)
            } else {
                // Continue game
                displayQuestion(for: .startGame)
            }
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
            case .startGame:
                let button = GameButton(title: answer, view: stackView)
                button.addTarget(self, action: #selector(verifyAnswer), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            case .playAgain:
                countdownTimerLabel.isHidden = true
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
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: Double(quizManager.secondsPerRound), target: self, selector: #selector(ViewController.nextRound), userInfo: nil, repeats: true)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCountdown), userInfo: nil, repeats: true)
    }
    
    func beginRound() {
        timer.invalidate()
        countdownTimer.invalidate()
        countdownSeconds = quizManager.secondsPerRound
        countdownTimerLabel.text = "\(quizManager.secondsPerRound)"
        questionCorrectLabel.isHidden = true
    }
    func createNextQuestionButton() {
        let button = GameButton(title: "Next Question", view: stackView)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(nextRound), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    func endRound() {
        timer.invalidate()
        countdownTimer.invalidate()
        questionCorrectLabel.text = ""
        questionCorrectLabel.isHidden = false
        for view in stackView.subviews {
            if let button = view as? UIButton {
                button.isEnabled = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func verifyAnswer(_ sender: UIButton) {
        guard let selectedAnswer = sender.currentTitle else {
            fatalError()
        }
        
        timer.invalidate()
        countdownTimer.invalidate()
        questionCorrectLabel.text = ""
        questionCorrectLabel.isHidden = false
        // TODO: EndRound
        
        if quizManager.checkAnswer(selectedAnswer) {
            questionCorrectLabel.text = "Correct!"
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            questionCorrectLabel.text = "Sorry, that's not it."
            sender.backgroundColor = #colorLiteral(red: 0.7179965102, green: 0.194347001, blue: 0.2058225411, alpha: 1)
            for view in stackView.subviews {
                if let button = view as? UIButton {
                    if button.currentTitle == quizManager.correctAnswer {
                        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    }
                }
            }
        }
        createNextQuestionButton()
    }
    
    @objc func lightningMode() {
        isLightningModeOn = true
        nextRound()
    }
    
    @objc func normalMode() {
        nextRound()
    }
    
    @objc func playAgain() {
        isLightningModeOn = false
        initialSetup(title: welcomeBack)
    }
    
    @objc func displayCountdown() {
        countdownSeconds -= 1
        countdownTimerLabel.text = "\(countdownSeconds)"
    }
}

