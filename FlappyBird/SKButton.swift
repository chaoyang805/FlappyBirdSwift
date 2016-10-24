//
//  SKButton.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit

class SKButton: SKSpriteNode {
    
    private var target: AnyObject?
    private var clickSelector: Selector!
    private(set) var state: SKButtonState = .normal {
        didSet {
            switch state {
            case .normal:
                
                self.position.offsetByDeltaX(0, deltaY: 3)
            case .highLighted:
                self.position.offsetByDeltaX(0, deltaY: -3)
            }
        }
    }
    
    public func addTarget(_ target: AnyObject?, selector: Selector) {
        isUserInteractionEnabled = true
        self.target = target
        
        self.clickSelector = selector
    }
    
    let buttonSound = SKAction.playSoundFileNamed("sfx_swooshing.mp3", waitForCompletion: false)
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.state = .highLighted
        self.run(buttonSound, withKey: "buttonSound")
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.state = .normal
        if self.frame.contains(touches.first!.location(in: self.parent!)) {
            if target != nil && target!.responds(to: clickSelector) {
                let _ = target!.perform(clickSelector, with: self)
            }
        }
        
    }
    
}

public enum SKButtonState {
    case normal
    case highLighted
}

