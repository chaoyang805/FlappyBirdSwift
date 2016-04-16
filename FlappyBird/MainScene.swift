//
//  MainScene.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/14.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit

let EdgeCategory: UInt32 = 0x1 << 0
let FloorCategory: UInt32 = 0x1 << 1
let BirdCategory: UInt32 = 0x1 << 2
let BlockCategory: UInt32 = 0x1 << 3

class MainScene: SKScene,SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    var bird: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var birdTextureAtlas: SKTextureAtlas!
    var groundTextureAtlas: SKTextureAtlas!
    
    var birdTextures: [SKTexture]!
    var groundTextures: [SKTexture]!
    
    var started = false
    
    var gameOver = false
    
    override init(size: CGSize) {
        super.init(size: size)
        let physicsFrame = CGRect(x: self.frame.origin.x - 25, y: self.frame.origin.y, width: self.frame.width + 50, height: self.frame.height)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: physicsFrame)
        physicsBody?.categoryBitMask = EdgeCategory
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = 0
        self.physicsWorld.contactDelegate = self
        
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
        bird.setScale(1.5)
        self.bird.position = CGPoint(x: self.frame.width / 3, y: CGRectGetMidY(self.frame))
        let action = SKAction.animateWithTextures(self.birdTextures, timePerFrame: 0.1)
        self.bird.runAction(SKAction.repeatActionForever(action),withKey: "birdFly")
        self.addChild(self.bird)
        
        
        bird.physicsBody = SKPhysicsBody(rectangleOfSize: bird.frame.size)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = BirdCategory
        bird.physicsBody?.contactTestBitMask = BlockCategory | FloorCategory
        bird.physicsBody?.collisionBitMask = FloorCategory | BlockCategory
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
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.categoryBitMask = FloorCategory
        ground.physicsBody?.contactTestBitMask = 0
        ground.physicsBody?.collisionBitMask = 0
       
    }
    
    var scale: CGFloat!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var moveToView = false
    override func didMoveToView(view: SKView) {
        moveToView = true
    }
    
    var lastUpdateTime: NSTimeInterval = -1
    var pipeGeneragtor: PipeGenerator!
    
    override func update(currentTime: NSTimeInterval) {
        
        if !moveToView || ground == nil || bird == nil {
            return
        }
        
        if gameOver {
            return
        }
        
        if lastUpdateTime <= 0 {
            pipeGeneragtor = PipeGenerator(sceneSize: self.frame.size, floorHeight: ground.frame.height)
            lastUpdateTime = currentTime
        }
        
        if currentTime - lastUpdateTime >= 4 {
            let pipes = pipeGeneragtor.getPipe()
            
            self.addChild(pipes.downBlock)
            self.addChild(pipes.upBlock)
            
            lastUpdateTime = currentTime
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameOver {
            return
        }
        
        if !started {
            started = true
            bird.physicsBody?.affectedByGravity = true
            return
        }
        
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
    }
    
    // MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        switch (nodeA?.physicsBody?.categoryBitMask)! | (nodeB?.physicsBody?.categoryBitMask)! {
        case BirdCategory | BlockCategory:
            onGameOver()
            
        case BirdCategory | FloorCategory:
            onGameOver()
            
        case BlockCategory | EdgeCategory:
            if nodeA?.physicsBody?.categoryBitMask < nodeB?.physicsBody?.categoryBitMask {
                pipe(nodeB, contactEdge: nodeA)
            } else {
                pipe(nodeA, contactEdge: nodeB)
            }
            
        default:
            break
        }
    }
    
    func onGameOver() {
        for child in children {
            child.removeAllActions()
        }
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.affectedByGravity = false
        
        gameOver = true
        NSLog("gameOver")
    }
    
    func tryAgain() {
        gameOver = false
        // TODO
    }
    
    func pipe(pipe: SKNode?,contactEdge edge: SKNode?) {
        if pipe?.position.x <= 0 {
            pipe?.removeFromParent()
        }
    }
}

extension CGSize {
    func CGSizeWithScale(scale: CGFloat) -> CGSize {
        return CGSizeMake(self.width * scale, self.height * scale)
    }
}