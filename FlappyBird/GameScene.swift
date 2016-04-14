//
//  GameScene.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/14.
//  Copyright (c) 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit
//let floorActionImages = ["a0.png","a1.png","a2.png","a3.png","a4.png","a5.png","a6.png","a7.png","a8.png","a9.png","a10.png","a11.png","a12.png"]
let birdImages = ["Bird0","Bird1","Bird2"]
class GameScene: SKScene {
    
    var groundFrames: [SKTexture] = []
    var birdFrames: [SKTexture] = []
    
    var bird: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var walkFrames: [SKTexture] = []
    var bear: SKSpriteNode!
 
    override func didMoveToView(view: SKView) {
        
    }
    private func walkingBear() {
        let action = SKAction.repeatActionForever(SKAction.animateWithTextures(walkFrames, timePerFrame: 0.1, resize: false, restore: true))
        bear.runAction(action, withKey: "bearWalk")
    }
    
    /**
     根据存着图片名称的数组创建textures
     
     - parameter imageNames: 图片名称数组
     
     - returns: textures数组
     */
    private func createTexturesWithImageNames(imageNames: [String]) -> [SKTexture] {
        var textures: [SKTexture] = []
        for imageName in imageNames {
            let texture = SKTexture(imageNamed: imageName)
            textures.append(texture)
        }
        return textures
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       /* Called when a touch begins */
//        
//        for _ in touches {
//            NSLog("touched")
//            bird.physicsBody?.affectedByGravity = true
//        }
//    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
