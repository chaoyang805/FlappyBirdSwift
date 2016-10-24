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

import SpriteKit

class SKButton: SKSpriteNode {
    
    private var target: AnyObject?
    private var clickSelector: Selector!
    private(set) var state: SKButtonState = .normal {
        didSet {
            switch state {
            case .normal:
                
                self.position.offsetByDeltaX(0, deltaY: 3)
            case .highLighted:
                self.position.offsetByDeltaX(0, deltaY: -3)
            }
        }
    }
    
    public func addTarget(_ target: AnyObject?, selector: Selector) {
        isUserInteractionEnabled = true
        self.target = target
        
        self.clickSelector = selector
    }
    
    let buttonSound = SKAction.playSoundFileNamed("sfx_swooshing.mp3", waitForCompletion: false)
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.state = .highLighted
        self.run(buttonSound, withKey: "buttonSound")
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.state = .normal
        if self.frame.contains(touches.first!.location(in: self.parent!)) {
            if target != nil && target!.responds(to: clickSelector) {
                let _ = target!.perform(clickSelector, with: self)
            }
        }
        
    }
    
}

public enum SKButtonState {
    case normal
    case highLighted
}

