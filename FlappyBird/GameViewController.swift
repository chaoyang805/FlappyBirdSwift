//
//  GameViewController.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/14.
//  Copyright (c) 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        let scene = WelcomeScene(fileNamed: "WelcomeScene")
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
