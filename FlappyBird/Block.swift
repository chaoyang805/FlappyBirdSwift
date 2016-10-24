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
    
    
    class func blockInDirection(_ direction: Direction, withHeightRatio ratio: CGFloat) -> Block {
        let instance: Block!
        switch direction {
        case .up:
            let rect = CGRect(x: 0, y: 1 - ratio, width: 1, height: ratio)
            let scaledBlock = SKTexture(rect: rect, in: upBlockTexture)
            instance = Block(texture: scaledBlock)
        case .down:
            let rect = CGRect(x: 0, y: 0, width: 1, height: ratio)
            let scaledBlock = SKTexture(rect: rect, in: downBlockTexture)
            instance = Block(texture: scaledBlock)
        }
        instance.xScale = 1.7
        instance.yScale = 1.9
        // setup physicsbody
        instance.physicsBody = SKPhysicsBody(rectangleOf: instance.frame.size)
        instance.physicsBody?.affectedByGravity = false
        instance.physicsBody?.allowsRotation = false
        instance.physicsBody?.categoryBitMask = BlockCategory
        instance.physicsBody?.contactTestBitMask = EdgeCategory
        instance.physicsBody?.collisionBitMask = 0
        instance.physicsBody?.restitution = 0
        // move
        instance.startMove()
        return instance
    }
    
    func startMove() {
        self.run(SKAction.repeatForever(SKAction.moveBy(x: -25, y: 0, duration: 0.3)))
    }
    
}

enum Direction: Int {
    case up
    case down
}
