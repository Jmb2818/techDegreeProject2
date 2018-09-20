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
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizManager.startGame()
        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func displayQuestion() {
        let question = quizManager.getQuestion()
        questionField.text = question.question
        layoutButtons(with: question.answers, into: stackView)
        
        //TODO: Move this to quizmanager at the end of the getQuestion()
        quizManager.correctAnswer = question.correctAnswer
    }
    
    func displayScore() {
        // Display play again button
        layoutButtons(with: ["Play Again"], into: stackView)
        
        questionField.text = "Way to go!\nYou got \(quizManager.correctQuestions) out of \(quizManager.questionsPerRound) correct!"
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
    
    private func layoutButtons(with array: [String], into stackView: UIStackView) {
        // Remove any buttons that may already be in the stack view from the last round
        if !stackView.subviews.isEmpty {
            for view in stackView.subviews {
                view.removeFromSuperview()
            }
        }
        // For each answer add a button, if play again button then only present that button
        for answer in array {
            if answer == "Play Again" {
                let button = UIButton()
                button.backgroundColor = .black
                button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                button.widthAnchor.constraint(equalToConstant: stackView.frame.width - 20.0)
                button.setTitle(answer, for: .normal)
                button.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            } else {
                let button = UIButton()
                button.backgroundColor = .black
                button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                button.widthAnchor.constraint(equalToConstant: stackView.frame.width - 20.0)
                button.setTitle(answer, for: .normal)
                button.addTarget(self, action: #selector(verifyAnswer), for: .touchUpInside)
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
    
    @objc func playAgain() {
        quizManager.resetGame()
        nextRound()
    }
    
    
}

