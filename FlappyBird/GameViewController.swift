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
//        let scene = MainScene(size: CGSize(width: 320, height: 568))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        scene?.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
