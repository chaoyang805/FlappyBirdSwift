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

    override func didMove(to view: SKView) {
        
        initBird()
        initButton()
        addGround()
        
    }
    
    private func initBird() {
        let bird = childNode(withName: "Bird")
        bird?.setScale(1.5)
        let moveUpAction = SKAction.move(by: CGVector(dx:0,dy:10), duration: 0.3)
        moveUpAction.timingMode = .easeInEaseOut
        
        let moveDownAction = SKAction.move(by: CGVector(dx:0,dy: -10), duration: 0.3)
        moveDownAction.timingMode = .easeInEaseOut
        let action = SKAction.sequence([moveUpAction,moveDownAction])
        bird?.run(SKAction.repeatForever(action), withKey: "birdShake")
    }
    
    private func initButton() {
        
        let start = SKButton(imageNamed: "StartButton")
        let rank = SKButton(imageNamed: "RankButton")
        start.position = CGPoint(x: 85.79, y: 170.15)
        rank.position = CGPoint(x: 236.309, y: 170.15)
        start.addTarget(self, selector: #selector(WelcomeScene.startGame(_:)))
        rank.addTarget(self, selector: #selector(WelcomeScene.ranking(_:)))
        start.setScale(1.5)
        rank.setScale(1.5)
        addChild(start)
        addChild(rank)
    }
    
    var floor: SKSpriteNode!
    var groundTextureAtlas: SKTextureAtlas!
    var groundTextures: [SKTexture]!
    
    private func addGround() {
        groundTextureAtlas = SKTextureAtlas(named: "GroundImages")
        groundTextures = []
        for i in 1..<groundTextureAtlas.textureNames.count {
            let textureName = NSString(format: "ground%d", i) as String
            let texture = groundTextureAtlas.textureNamed(textureName)
            
            groundTextures.append(texture)
        }
        floor = SKSpriteNode(texture: groundTextures[0])
        floor.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let scale = self.frame.width / floor.frame.width
        floor.setScale(scale)
        
        floor.position = CGPoint(x: floor.frame.width / 2, y: floor.frame.height / 2)
        let action = SKAction.animate(with: groundTextures, timePerFrame: 0.024, resize: false, restore: true)
        floor.run(SKAction.repeatForever(action), withKey: "groundMove")
        addChild(floor)
        
        
    }
    
    // MARK: button selectors
    func rateMe(_ sender: SKButton) {
        NSLog("rate me...")
    }
    
    func startGame(_ sender: SKButton) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let size = CGSize(width: 320, height: 568)
        self.view?.presentScene(MainScene(size: size), transition: transition)
    }
    
    func ranking(_ sender: SKButton) {
        
    }
}
