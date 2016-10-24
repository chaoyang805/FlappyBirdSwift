//
//  RecordManager.swift
//  FlappyBird
//
//  Created by chaoyang805 on 16/4/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//
import UIKit

class RecordManager: NSObject {
    var userDefault: UserDefaults
    
    var lastRecord: Int {
        get {
            return userDefault.integer(forKey: kRecord)
        }
        set {
            userDefault.set(newValue, forKey: kRecord)
        }
    }
    let kRecord = "HighestScore"
    
    override init() {
        userDefault = UserDefaults.standard
        super.init()
    }
    /**
     写入新的记录
     
     - parameter newScore: 新分数
     
     - returns: 如果超过旧记录，返回true
     */
    func writeNewScore(_ newScore: Int) -> Bool {
        
        if lastRecord < newScore {
            lastRecord = newScore
            return true
        }
        return false
    }
}
