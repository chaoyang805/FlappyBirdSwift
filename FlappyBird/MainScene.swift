//
//  MainScene.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/14.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


let EdgeCategory: UInt32 = 0x1 << 0
let FloorCategory: UInt32 = 0x1 << 1
let BirdCategory: UInt32 = 0x1 << 2
let BlockCategory: UInt32 = 0x1 << 3
let BonusLineCategory: UInt32 = 0x1 << 4
let CategoryNone: UInt32 = 0

class MainScene: SKScene,SKPhysicsContactDelegate {
    // MARK: Properties
    var background: SKSpriteNode!
    var bird: SKSpriteNode!
    var floor: SKSpriteNode!
    var bonusLine: SKSpriteNode!
    var bonusLabel: BonusLabel!
    
    var birdTextureAtlas: SKTextureAtlas!
    var groundTextureAtlas: SKTextureAtlas!
    
    var birdTextures: [SKTexture]!
    var groundTextures: [SKTexture]!
    
    var started = false
    var gameOver = false
    
    lazy var recordManager = RecordManager()
    
    override init(size: CGSize) {
        super.init(size: size)

        let physicsFrame = CGRect(x: self.frame.origin.x - 50, y: self.frame.origin.y, width: self.frame.width + 100, height: self.frame.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsFrame)
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
        
        bonusLabel = BonusLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        self.addGround()
        self.addBird()
        self.addBonusLine()
        self.addGameGuide()
        self.bonusLabel.attachToScene(self)
    }
    
    func addBonusLine() {
    
        self.bonusLine = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1, height: 1))
        self.bonusLine.position = CGPoint(x: self.bird.position.x, y: self.floor.frame.height + 5)
        self.bonusLine.physicsBody = SKPhysicsBody(rectangleOf: self.bonusLine.size)
        self.bonusLine.physicsBody?.affectedByGravity = false
        self.bonusLine.physicsBody?.allowsRotation = false
        self.bonusLine.physicsBody?.categoryBitMask = BonusLineCategory
        self.bonusLine.physicsBody?.contactTestBitMask = BlockCategory
        self.bonusLine.physicsBody?.collisionBitMask = 0
        
        self.addChild(self.bonusLine)
    }
    
    func addBird() {
        let texture0 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[0])
        let texture1 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[1])
        let texture2 = self.birdTextureAtlas.textureNamed(self.birdTextureAtlas.textureNames[2])
        self.birdTextures = [texture0,texture1,texture2]
        
        self.bird = SKSpriteNode(texture: self.birdTextures[0])
        bird.setScale(2.5)
        self.bird.position = CGPoint(x: self.frame.width / 3, y: self.frame.midY)
        
        let moveUpAction = SKAction.move(by: CGVector(dx:0,dy:10), duration: 0.3)
        moveUpAction.timingMode = .easeInEaseOut
        let moveDownAction = SKAction.move(by: CGVector(dx:0,dy: -10), duration: 0.3)
        moveDownAction.timingMode = .easeInEaseOut
        let shakeAction = SKAction.sequence([moveUpAction,moveDownAction])
        bird?.run(SKAction.repeatForever(shakeAction), withKey: "birdShake")
        self.addChild(self.bird)
        
        bird.zPosition = 1
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.frame.size)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = BirdCategory
        bird.physicsBody?.contactTestBitMask = BlockCategory | FloorCategory
        bird.physicsBody?.collisionBitMask = FloorCategory
        
        
    }
    
    func addGround() {
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
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.frame.size)
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.categoryBitMask = FloorCategory
        floor.physicsBody?.contactTestBitMask = 0
        floor.physicsBody?.collisionBitMask = 0
    }
    
    func addGameGuide() {
        let guideNode = SKSpriteNode(imageNamed: "Guide")
        guideNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 10)
        guideNode.setScale(2.5)
        guideNode.name = "GuideNode"
        addChild(guideNode)
        
        let getReady = SKSpriteNode(imageNamed: "GetReady")
        getReady.position = CGPoint(x: guideNode.position.x, y: guideNode.position.y + guideNode.frame.width / 2 + getReady.frame.height / 2 + 10)
        getReady.setScale(2)
        getReady.name = "GetReady"
        addChild(getReady)
    }
    
    func flyTheBird() {
        self.bird.removeAction(forKey: "birdShake")
        let action = SKAction.animate(with: self.birdTextures, timePerFrame: 0.1)
        self.bird.run(SKAction.repeatForever(action),withKey: "birdFly")
        bird.physicsBody?.affectedByGravity = true
    }
    
    
    var lastUpdateTime: TimeInterval = -1
    var blockProvider: BlockProvider!
    
    override func update(_ currentTime: TimeInterval) {
        
        if started {
            
            if lastUpdateTime <= 0 {
                blockProvider = BlockProvider(sceneSize: self.frame.size, floorHeight: floor.frame.height)
                lastUpdateTime = currentTime
            }
            
            if currentTime - lastUpdateTime >= 2 {
                let blocks = blockProvider.getBlocks()
                
                self.addChild(blocks.downBlock)
                self.addChild(blocks.upBlock)
                
                lastUpdateTime = currentTime
            }
        }
    }
    let birdRotateAction = SKAction.rotate(toAngle: CGFloat(M_PI_4 / 2), duration: 0.2, shortestUnitArc: true)
    let birdEmptyAction = SKAction.rotate(toAngle: CGFloat(0), duration: 0.3, shortestUnitArc: true)
    let birdDropAction = SKAction.rotate(toAngle: CGFloat(-M_PI_2), duration: 0.3, shortestUnitArc: true)
    var actionSequence: SKAction {
        return SKAction.sequence([birdRotateAction,birdEmptyAction,birdDropAction])
    }
    let soundAction: SKAction = SKAction.playSoundFileNamed("sfx_wing.mp3", waitForCompletion: false)
    
    // MARK: touches callback
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver {
            return
        }
       
        if !started {
            started = true
            childNode(withName: "GuideNode")?.removeFromParent()
            childNode(withName: "GetReady")?.removeFromParent()
            flyTheBird()
            return
        }
        if bird.position.y < self.frame.height + bird.frame.height / 2 {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
        }
        if let cacheAction = bird.action(forKey: "BirdRotate") {
            bird.run(cacheAction, withKey: "BirdRotate")
        } else {
            bird.run(actionSequence, withKey: "BirdRotate")
        }
        bird.run(soundAction, withKey: "Wing")
        
    }

    
    // MARK: SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        switch (nodeA?.physicsBody?.categoryBitMask)! | (nodeB?.physicsBody?.categoryBitMask)! {
        case BirdCategory | BlockCategory:
            onGameOver(true)
            break
            
        case BirdCategory | FloorCategory:
            onGameOver(false)
            break
            
        case BlockCategory | EdgeCategory:
            if nodeA?.physicsBody?.categoryBitMask < nodeB?.physicsBody?.categoryBitMask {
                pipe(nodeB, contactEdge: nodeA)
            } else {
                pipe(nodeA, contactEdge: nodeB)
            }
        case BonusLineCategory | BlockCategory:
            self.run(bonusSound, withKey: "bonusSound")
            bonusLabel.onAddBonus()
        default:
            break
        }
    }

    let bonusSound = SKAction.playSoundFileNamed("sfx_point.mp3", waitForCompletion: false)
    let birdDiedSound = SKAction.playSoundFileNamed("sfx_die.mp3", waitForCompletion: false)
    let birdHitSound = SKAction.playSoundFileNamed("sfx_hit.mp3", waitForCompletion: false)
    // MARK: game logic
    func onGameOver(_ hitBlock: Bool) {
        if gameOver {
            return
        }
        for child in children {
            child.removeAllActions()
        }
        
        let flashNode = SKSpriteNode(color: UIColor.white, size: self.frame.size)
        flashNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        flashNode.alpha = 0
        flashNode.zPosition = 2
        addChild(flashNode)
        let fade1 = SKAction.fadeAlpha(to: 0.7, duration: 0.1)
        let fade2 = SKAction.fadeAlpha(to: 0, duration: 0.1)
        flashNode.run(SKAction.sequence([fade1,fade2]), completion: {
            flashNode.removeFromParent()
        }) 
        
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.affectedByGravity = false
        bird.run(birdHitSound, withKey: "birdHitSound")
        
        if hitBlock {
            bird.run(birdDiedSound, withKey: "birdDiedSound")
        }
       
        let birdDied = SKAction.rotate(toAngle: CGFloat(-M_PI_2), duration: 0.1, shortestUnitArc: true)
        let birdDown = SKAction.moveTo(y: floor.position.y + floor.frame.height / 2, duration: 0.5)
        
        bird.run(SKAction.sequence([birdDied,birdDown]), completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_MSEC * 300)) / Double(NSEC_PER_SEC), execute: {
                self.showGameOver()
            })
        })
        
        gameOver = true
        started = false
    }
    
    var recordLabel = BonusLabel(score: 10)
    func showGameOver() {
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.setScale(2)
        gameOver.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4 * 3)
        addChild(gameOver)
        
        let scoreBoard = SKSpriteNode(imageNamed: "ScoreInfo")
        scoreBoard.zPosition = 1
        scoreBoard.position = CGPoint(x: self.frame.width / 2, y: -scoreBoard.frame.height)
        scoreBoard.setScale(2)
        
        self.addChild(scoreBoard)
        self.bonusLabel.attachToNode(scoreBoard, inPosition: CGPoint(x: 40, y: 7))
        
        let _ = recordManager.writeNewScore(bonusLabel.totalScore)
        recordLabel.totalScore = recordManager.lastRecord
        self.recordLabel.attachToNode(scoreBoard, inPosition: CGPoint(x: 40, y: -13))
        
        let moveUp = SKAction.moveBy(x: 0, y: 5, duration: 0.1)
        let moveDown = SKAction.moveBy(x: 0, y: -5, duration: 0.1)
        gameOver.run(SKAction.sequence([moveUp,moveDown]), completion: {
            
            let showAction = SKAction.moveTo(y: self.frame.height / 2, duration: 0.5)
            showAction.timingMode = .easeOut
            scoreBoard.run(showAction, completion: {
                
                let retryBtn = SKButton(imageNamed: "StartButton")
                retryBtn.addTarget(self, selector: #selector(MainScene.tryAgain(_:)))
                retryBtn.setScale(1.5)
                retryBtn.zPosition = 1
                retryBtn.position = CGPoint(x: 85.79, y: 170.15)
                self.addChild(retryBtn)
                
                let rankBtn = SKButton(imageNamed: "RankButton")
                rankBtn.addTarget(self, selector: #selector(MainScene.ranking(_:)))
                rankBtn.setScale(1.5)
                rankBtn.zPosition = 1
                rankBtn.position = CGPoint(x: 236.309, y: 170.15)
                self.addChild(rankBtn)
            })
        }) 
        
    }
    
    // MARK: Button selector
    func ranking(_ sender: SKButton) {
        NSLog("see ranking...")
    }
    
    func tryAgain(_ sender: SKButton) {
        gameOver = false
        
        self.view?.presentScene(MainScene(size: CGSize(width: 320, height: 568)),transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func pipe(_ pipe: SKNode?,contactEdge edge: SKNode?) {
        if pipe?.position.x <= 0 {
            
            pipe?.removeAllActions()
            pipe?.removeFromParent()
            pipe?.position = CGPoint(x: self.size.width, y: pipe!.position.y)
        }
    }
}

extension CGSize {
    func CGSizeWithScale(_ scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}
