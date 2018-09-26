//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var quizManager = QuizManager()
    var roundTimer = Timer()
    var countdownTimer = Timer()
    var countdownSeconds = 15
    var isLightningModeOn = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionCorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialSetup(title: UserStrings.General.quizWelcome)
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
        layoutButtons(with: UserStrings.General.playAgainArray, into: stackView, for: .playAgain)
        timerLabel.isHidden = true
        
        questionField.text = "Way to go!\nYou got \(quizManager.correctQuestions) out of \(quizManager.questionsPerRound) correct!"
    }
    
    func initialSetup(title: String) {
        // load everything up
        quizManager.loadGameStartSound()
        quizManager.startGame()
        // Display initial buttons to start game in specific round type
        layoutButtons(with: UserStrings.General.initialSetupArray, into: stackView, for: .initialSetup)
        questionField.text = title
        countdownTimerLabel.isHidden = true
        questionCorrectLabel.text = UserStrings.General.lightningModeInfo
        timerLabel.isHidden = true
        isLightningModeOn = false
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
                timerLabel.isHidden = false
                runTimer()
                displayQuestion(for: .startGame)
            } else {
                // Continue game
                displayQuestion(for: .startGame)
            }
        }
    }
    
    func layoutButtons(with array: [String], into stackView: UIStackView, for section: QuizSection) {
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
                if answer == UserStrings.General.normalModeName {
                    button.addTarget(self, action: #selector(normalMode), for: .touchUpInside)
                } else {
                    button.addTarget(self, action: #selector(lightningMode), for: .touchUpInside)
                }
                stackView.addArrangedSubview(button)
                
            }
        }
    }
    
    func runTimer() {
        
        roundTimer = Timer.scheduledTimer(timeInterval: Double(quizManager.secondsPerRound), target: self, selector: #selector(ViewController.nextRound), userInfo: nil, repeats: true)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCountdown), userInfo: nil, repeats: true)
    }
    
    func beginRound() {
        roundTimer.invalidate()
        countdownTimer.invalidate()
        countdownSeconds = quizManager.secondsPerRound
        countdownTimerLabel.text = "\(quizManager.secondsPerRound)"
        questionCorrectLabel.isHidden = true
    }
    func createNextQuestionButton() {
        let button = GameButton(title: UserStrings.General.nextQuestion, view: stackView)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5921568627, blue: 0.4352941176, alpha: 1)
        button.addTarget(self, action: #selector(nextRound), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    func endRound() {
        roundTimer.invalidate()
        countdownTimer.invalidate()
        questionCorrectLabel.text = ""
        questionCorrectLabel.isHidden = false
        for view in stackView.subviews {
            if let button = view as? UIButton {
                button.isEnabled = false
                button.alpha = 0.60
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func verifyAnswer(_ sender: UIButton) {
        guard let selectedAnswer = sender.currentTitle else {
            // If the button does not have a title then crash
            fatalError()
        }
        
        endRound()
        
        if quizManager.checkAnswer(selectedAnswer) {
            questionCorrectLabel.text = UserStrings.General.correctAnswer
            questionCorrectLabel.textColor = #colorLiteral(red: 0, green: 0.537254902, blue: 0.3960784314, alpha: 1)
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            sender.alpha = 1.0
        } else {
            questionCorrectLabel.text = UserStrings.General.incorrectAnswer
            questionCorrectLabel.textColor = #colorLiteral(red: 1, green: 0.6156862745, blue: 0.2745098039, alpha: 1)
            sender.backgroundColor = #colorLiteral(red: 0.7179965102, green: 0.194347001, blue: 0.2058225411, alpha: 1)
            sender.alpha = 1.0
            for view in stackView.subviews {
                if let button = view as? UIButton {
                    if button.currentTitle == quizManager.correctAnswer {
                        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                        button.alpha = 1.0
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
        initialSetup(title: UserStrings.General.playAgainSelect)
    }
    
    @objc func displayCountdown() {
        countdownSeconds -= 1
        countdownTimerLabel.text = "\(countdownSeconds)"
    }
}

