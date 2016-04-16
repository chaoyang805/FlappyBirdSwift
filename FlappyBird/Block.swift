//
//  Block.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/16.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SpriteKit
class Block: SKSpriteNode {
    
    static var upBlockTexture = SKTexture(imageNamed: "UpPipe")
    static var downBlockTexture = SKTexture(imageNamed: "DownPipe")
    
    
    class func blockInDirection(direction: Direction, withHeightRatio ratio: CGFloat) -> Block {
        let instance: Block!
        NSLog("ratio:\(ratio)")
        switch direction {
        case .Up:
            let rect = CGRect(x: 0, y: 1 - ratio, width: 1, height: ratio)
            let scaledBlock = SKTexture(rect: rect, inTexture: upBlockTexture)
            NSLog("scaledUpBlock:\(scaledBlock.size()),rect:\(rect)")
            instance = Block(texture: scaledBlock)
        case .Down:
            let rect = CGRect(x: 0, y: 0, width: 1, height: ratio)
            let scaledBlock = SKTexture(rect: rect, inTexture: downBlockTexture)
            NSLog("scaledDownBlock:\(scaledBlock.size()),rect:\(rect)")
//            NSLog("scaledBlockheight:\(scaledBlock))
            instance = Block(texture: scaledBlock)
        }
        NSLog("\(instance.frame.size.height)")
        instance.xScale = 1.5
        instance.yScale = 2
        // setup physicsbody
        instance.physicsBody = SKPhysicsBody(rectangleOfSize: instance.frame.size)
        instance.physicsBody?.affectedByGravity = false
        instance.physicsBody?.allowsRotation = false
        instance.physicsBody?.categoryBitMask = BlockCategory
        instance.physicsBody?.contactTestBitMask = EdgeCategory
        instance.physicsBody?.collisionBitMask = 0
        instance.physicsBody?.restitution = 0
        // move
        instance.runAction(SKAction.repeatActionForever(SKAction.moveByX(-18, y: 0, duration: 0.3)))
        return instance
    }
    
    
}

enum Direction: Int {
    case Up
    case Down
}
