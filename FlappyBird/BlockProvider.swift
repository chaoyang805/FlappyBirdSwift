/*
 * Copyright 2016 chaoyang805 zhangchaoyang805@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
        
        SKTexture.preload([upPipeTexture,downPipeTexture]) {
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
        
        let upBlock = Block.blockInDirection(.up, withHeightRatio: ratio)
        let downBlock = Block.blockInDirection(.down, withHeightRatio: 1 - ratio)
        
        upBlock.position = CGPoint(x: sceneSize.width, y: upBlock.frame.height / 2 + floorHeight)
        downBlock.position = CGPoint(x: sceneSize.width, y: sceneSize.height - downBlock.frame.height / 2)
        
        let result = (upBlock, downBlock)
        cachedBlocks[key] = result
        return result
    }
    
}
