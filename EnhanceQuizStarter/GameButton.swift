//
//  GameButton.swift
//  EnhanceQuizStarter
//
//  Created by Joshua Borck on 9/22/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    
    // Initialize game button for the stack view so they are all the same
    
    convenience init(title: String, view: UIStackView) {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
        self.widthAnchor.constraint(equalToConstant: view.frame.width - 20.0)
        self.setTitle(title, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0.4705882353, blue: 0.5910003064, alpha: 1)
        tintColor = .white
        layer.cornerRadius = 15.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError() 
    }
}
