//
//  TunnelGenerator.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/15.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SpriteKit

class BlockProvider: NSObject {
    
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
    
    var cachedBlocks: [Int : (Block,Block)] = Dictionary()
    
    func getBlocks() -> (upBlock: Block, downBlock: Block) {
        
        let ratio = CGFloat(arc4random_uniform(6) + 2) / 10.0
        let key = Int(ratio * 10)
        if let cache = cachedBlocks[key] {
            if cache.0.parent == nil && cache.1.parent == nil {
                
                cache.0.startMove()
                cache.1.startMove()
                
                return cache
            }
        }
        
        let upBlock = Block.blockInDirection(.Up, withHeightRatio: ratio)
        let downBlock = Block.blockInDirection(.Down, withHeightRatio: 1 - ratio)
        
        upBlock.position = CGPoint(x: sceneSize.width, y: upBlock.frame.height / 2 + floorHeight)
        downBlock.position = CGPoint(x: sceneSize.width, y: sceneSize.height - downBlock.frame.height / 2)
        
        let result = (upBlock, downBlock)
        cachedBlocks[key] = result
        return result
    }
    
}
