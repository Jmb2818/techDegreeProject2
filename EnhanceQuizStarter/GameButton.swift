//
//  GameButton.swift
//  EnhanceQuizStarter
//
//  Created by Joshua Borck on 9/22/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    
    convenience init(title: String, view: UIStackView) {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.widthAnchor.constraint(equalToConstant: view.frame.width - 20.0)
        self.setTitle(title, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        tintColor = .white
        layer.cornerRadius = 15.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}