//
//  MainScene.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/14.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit

class MainScene: SKScene {
    
    var background: SKSpriteNode!
    var bird: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var birdTextureAtlas: SKTextureAtlas!
    var groundTextureAtlas: SKTextureAtlas!
    
    var birdTextures: [SKTexture]!
    var groundTextures: [SKTexture]!
    
    var started = false
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        background = SKSpriteNode(texture: SKTexture(imageNamed: "Background"), size: size)
        self.addChild(background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        
        birdTextureAtlas = SKTextureAtlas(named: "BirdImages")
        groundTextureAtlas = SKTextureAtlas(named: "GroundImages")
        
        SKTextureAtlas.preloadTextureAtlases([birdTextureAtlas,groundTextureAtlas]) {
            
            self.addGround()
            self.addBird()
        }
      
    }
    
    func addBird() {
        let texture0 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[0])
        let texture1 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[1])
        let texture2 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[2])
        self.birdTextures = [texture0,texture1,texture2]
        
        self.bird = SKSpriteNode(texture: self.birdTextures[0])
        self.bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        let action = SKAction.animateWithTextures(self.birdTextures, timePerFrame: 0.1)
        self.bird.runAction(SKAction.repeatActionForever(action),withKey: "birdFly")
        self.addChild(self.bird)
        bird.physicsBody = SKPhysicsBody(rectangleOfSize: bird.frame.size)
        bird.physicsBody?.affectedByGravity = false
    }
    
    func addGround() {
        groundTextures = []
        for i in 1..<groundTextureAtlas.textureNames.count {
            let textureName = NSString(format: "ground%d", i) as String
            let texture = groundTextureAtlas.textureNamed(textureName)
            
            groundTextures.append(texture)
        }
        ground = SKSpriteNode(texture: groundTextures[0])
        ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        scale = self.frame.width / ground.frame.width
        ground.setScale(scale)
        
        ground.position = CGPoint(x: ground.frame.width / 2, y: ground.frame.height / 2)
        let action = SKAction.animateWithTextures(groundTextures, timePerFrame: 0.05, resize: false, restore: true)
        ground.runAction(SKAction.repeatActionForever(action), withKey: "groundMove")
        addChild(ground)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.frame.size)
    }
    
    var scale: CGFloat!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !started {
            started = true
            bird.physicsBody?.affectedByGravity = true
            return
        }
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
    }
}

extension CGSize {
    func CGSizeWithScale(scale: CGFloat) -> CGSize {
        return CGSizeMake(self.width * scale, self.height * scale)
    }
}