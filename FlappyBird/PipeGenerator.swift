//
//  TunnelGenerator.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/15.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SpriteKit
let gap: CGFloat = 90
class PipeGenerator: NSObject {
    
    var sceneSize: CGSize
    var floorHeight: CGFloat
    var upPipeTexture: SKTexture
    var downPipeTexture: SKTexture
    var textureInitialized = false
    
    init(sceneSize: CGSize,floorHeight: CGFloat) {
        self.sceneSize = sceneSize
        self.floorHeight = floorHeight
        
        upPipeTexture = SKTexture(imageNamed: "UpPipe")
        downPipeTexture = SKTexture(imageNamed: "DownPipe")
        
        super.init()
        
        SKTexture.preloadTextures([upPipeTexture,downPipeTexture]) {
            self.textureInitialized = true
        }
    }
    
    func getPipes() -> (upPipe: SKSpriteNode,downPipe: SKSpriteNode) {
        
        
        let ratio = CGFloat(arc4random_uniform(6) + 2) / 10.0
        
//        let upPipeHeight = (sceneSize.height - gap - floorHeight) * ratio
//        let downPipeHeight = (sceneSize.height - gap - floorHeight) * (1 - ratio)
        
        let upPipeRect = CGRect(x: 0, y: 1 - ratio, width: 1, height: ratio)
        let scaledUpPipe = SKTexture(rect: upPipeRect, inTexture: upPipeTexture)
        let upPipe = SKSpriteNode(texture: scaledUpPipe)
        
//        let upPipe = SKSpriteNode(texture: scaledTexture, size: CGSize(width: upPipeTexture.size().width, height: upPipeHeight))
        
        let downPipeRect = CGRect(x: 0, y: 0, width: 1, height: 1 - ratio)
        let scaledDownUPipe = SKTexture(rect: downPipeRect, inTexture: downPipeTexture)
        let downPipe = SKSpriteNode(texture: scaledDownUPipe)
        
//        let downPipe = SKSpriteNode(texture: downPipeTexture, size: CGSize(width: downPipeTexture.size().width, height: downPipeHeight))
        upPipe.xScale = 1.5
        upPipe.yScale = 2
        upPipe.position = CGPoint(x: sceneSize.width, y: upPipe.frame.height / 2 + floorHeight)
        downPipe.xScale = 1.5
        downPipe.yScale = 2
        downPipe.position = CGPoint(x: sceneSize.width, y: sceneSize.height - downPipe.frame.height / 2)
        
        upPipe.physicsBody = SKPhysicsBody(rectangleOfSize: upPipe.frame.size)
        upPipe.physicsBody?.velocity = CGVectorMake(-60, 0)
        upPipe.physicsBody?.affectedByGravity = false
        upPipe.physicsBody?.allowsRotation = false
        upPipe.physicsBody?.restitution = 0
        upPipe.physicsBody?.categoryBitMask = BlockCategory
        upPipe.physicsBody?.contactTestBitMask = EdgeCategory
        upPipe.physicsBody?.collisionBitMask = 0
        
        downPipe.physicsBody = SKPhysicsBody(rectangleOfSize: downPipe.frame.size)
        downPipe.physicsBody?.velocity = CGVectorMake(-60, 0)
        downPipe.physicsBody?.affectedByGravity = false
        downPipe.physicsBody?.allowsRotation = false
        downPipe.physicsBody?.restitution = 0
        downPipe.physicsBody?.categoryBitMask = BlockCategory
        downPipe.physicsBody?.contactTestBitMask = EdgeCategory
        downPipe.physicsBody?.collisionBitMask = 0
        
        return (upPipe,downPipe)
    }
    
}
