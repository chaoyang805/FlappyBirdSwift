//
//  BonusLabel.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//
import UIKit
import SpriteKit
class BonusLabel: NSObject {
    
    var totalScore = 0
    private var bitNode: SKSpriteNode
    private var tenNode: SKSpriteNode
    private var hundredNode: SKSpriteNode
    private var mainScene: SKScene!
    private var scoreTextures: [Int : SKTexture]
    
    private var bitScore: Int {
        return totalScore % 10
    }
    
    private var tenScore: Int {
        return totalScore % 100 / 10
    }
    
    private var hundredScore: Int {
        return totalScore / 100
    }
    
    convenience init(score: Int) {
        self.init()
        self.totalScore = score
    }
    
    
    
    override init() {
        bitNode = SKSpriteNode(imageNamed: "0")
        tenNode = SKSpriteNode(imageNamed: "0")
        hundredNode = SKSpriteNode(imageNamed: "0")
        bitNode.setScale(1.5)
        tenNode.setScale(1.5)
        hundredNode.setScale(1.5)
        scoreTextures = Dictionary()
        super.init()
        prepareTextures()
    }
    
    private func prepareTextures() {
        let atlas = SKTextureAtlas(named: "ScoreNumbers")
        atlas.preload {
            for textureName in atlas.textureNames {
                let texture = SKTexture(imageNamed: textureName)
                let index = Int(textureName.substring(to: textureName.characters.index(textureName.startIndex, offsetBy: 1)))
                self.scoreTextures[index!] = texture
            }

        }
    }
    func attachToScene(_ scene: SKScene) {
        mainScene = scene
        let position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 5 * 4)
        bitNode.position = position
        bitNode.zPosition = 1
        mainScene.addChild(bitNode)
        
    }
    
    func attachToNode(_ parentNode: SKNode,inPosition position: CGPoint) {

        if hundredScore > 0 {
            hundredNode.removeFromParent()
            tenNode.removeFromParent()
            bitNode.removeFromParent()
            hundredNode.setScale(0.5)
            tenNode.setScale(0.5)
            bitNode.setScale(0.5)
            tenNode.position = position
            bitNode.position = CGPoint(x: position.x + tenNode.frame.width / 2 + bitNode.frame.width / 2, y: position.y)
            hundredNode.position = CGPoint(x: position.x - tenNode.frame.width / 2 - hundredNode.frame.width / 2, y: position.y)
            parentNode.addChild(hundredNode)
            parentNode.addChild(tenNode)
            parentNode.addChild(bitNode)
        } else if tenScore > 0 {
            tenNode.removeFromParent()
            bitNode.removeFromParent()
            tenNode.setScale(0.5)
            bitNode.setScale(0.5)
            tenNode.position = CGPoint(x: position.x - tenNode.frame.width / 2, y: position.y)
            bitNode.position = CGPoint(x: position.x + bitNode.frame.width / 2, y: position.y)
            
            parentNode.addChild(tenNode)
            parentNode.addChild(bitNode)
        } else {
            bitNode.removeFromParent()
            
            bitNode.setScale(0.5)
            bitNode.position = position
            parentNode.addChild(bitNode)
        }
        hundredNode.zPosition = 1
        tenNode.zPosition = 1
        bitNode.zPosition = 1
        hundredNode.texture = scoreTextures[hundredScore]
        tenNode.texture = scoreTextures[tenScore]
        bitNode.texture = scoreTextures[bitScore]
    }
    
    func onAddBonus() {
        totalScore += 1
        
        if hundredScore > 0 {
            if hundredNode.parent == nil {
                tenNode.position.offsetByDeltaX(tenNode.frame.width / 2, deltaY: 0)
                bitNode.position.offsetByDeltaX(bitNode.frame.width / 2, deltaY: 0)
                hundredNode.position = CGPoint(x:mainScene.frame.width / 2 - tenNode.frame.width / 2 - hundredNode.frame.width / 2 + 2, y: mainScene.frame.height / 5 * 4)
                mainScene.addChild(hundredNode)
                hundredNode.zPosition = 1
            }
            hundredNode.texture = scoreTextures[hundredScore]
            tenNode.texture = scoreTextures[tenScore]
            bitNode.texture = scoreTextures[bitScore]
            
        }  else if tenScore > 0 {
            
            if tenNode.parent == nil {
                bitNode.position = CGPoint(x: mainScene.frame.width / 2 + bitNode.frame.width / 2 - 1, y: mainScene.frame.height / 5 * 4)
                tenNode.position = CGPoint(x: mainScene.frame.width / 2 - tenNode.frame.width / 2 + 1, y: mainScene.frame.height / 5 * 4)
                mainScene.addChild(tenNode)
                tenNode.zPosition = 1
            }
            tenNode.texture = scoreTextures[tenScore]
            bitNode.texture = scoreTextures[bitScore]
        } else {
            
            bitNode.texture = scoreTextures[bitScore]
        }
    }
    
}

extension CGPoint {
    
    mutating func offsetByDeltaX(_ deltaX: CGFloat,deltaY: CGFloat) {
        self.x += deltaX
        self.y += deltaY
    }
}
