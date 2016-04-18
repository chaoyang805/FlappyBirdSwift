//
//  SKButton.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit
public class SKButton: SKSpriteNode {
    
    private var target: AnyObject?
    private var clickSelector: Selector!
    private(set) var state: SKButtonState = .Normal {
        didSet {
            switch state {
            case .Normal:
                
                self.position.offsetByDeltaX(0, deltaY: 3)
            case .HighLighted:
                self.position.offsetByDeltaX(0, deltaY: -3)
            }
        }
    }
    
    public func addTarget(target: AnyObject?, selector: Selector) {
        userInteractionEnabled = true
        self.target = target
        self.clickSelector = selector
    }
    
    let buttonSound = SKAction.playSoundFileNamed("sfx_swooshing", waitForCompletion: false)
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.state = .HighLighted
        self.runAction(buttonSound, withKey: "buttonSound")
        
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.state = .Normal
        if self.frame.contains(touches.first!.locationInNode(self.parent!)) {
            if target != nil && target!.respondsToSelector(clickSelector) {
                target!.performSelector(clickSelector, withObject: self)
            }
        }
        
    }
}

public enum SKButtonState {
    case Normal
    case HighLighted
}

