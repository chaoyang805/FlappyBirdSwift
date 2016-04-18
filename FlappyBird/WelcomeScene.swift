//
//  WelcomeScene.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SpriteKit
class WelcomeScene: SKScene {

    override func didMoveToView(view: SKView) {
        let bird = childNodeWithName("Bird")
        bird?.setScale(1.5)
        let moveUpAction = SKAction.moveBy(CGVector(dx:0,dy:10), duration: 0.3)
        moveUpAction.timingMode = .EaseInEaseOut
        
        let moveDownAction = SKAction.moveBy(CGVector(dx:0,dy: -10), duration: 0.3)
        moveDownAction.timingMode = .EaseInEaseOut
        let action = SKAction.sequence([moveUpAction,moveDownAction])
        bird?.runAction(SKAction.repeatActionForever(action), withKey: "birdShake")
        
        let startBtn = childNodeWithName("StartButton") as! SKButton
        startBtn.addTarget(self, selector: #selector(WelcomeScene.startGame(_:)))
        
        let rankBtn = childNodeWithName("RankButton") as! SKButton
        rankBtn.addTarget(self, selector: #selector(WelcomeScene.ranking(_:)))
        
        let rateBtn = childNodeWithName("RateButton") as! SKButton
        rateBtn.addTarget(self, selector: #selector(WelcomeScene.rateMe(_:)))
    }
    
    // MARK: button selectors
    func rateMe(sender: SKButton) {
        NSLog("rate me...")
    }
    
    func startGame(sender: SKButton) {
        let transition = SKTransition.fadeWithDuration(0.5)
        let size = CGSizeMake(320, 568)
        self.view?.presentScene(MainScene(size: size), transition: transition)
    }
    
    func ranking(sender: SKButton) {
        
    }
}
