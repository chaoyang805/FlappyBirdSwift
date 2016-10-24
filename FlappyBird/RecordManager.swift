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
