//
//  Alarm.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/12/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class Alarm: NSObject {
    var daysToRepeat: [String]?
//    let snooze: Bool = false
    var key: String?
    var alarmLabel: String? = nil
    var time: String? = nil
    
    init(time: String, alarmLabel: String, daysToRepeat: [String]?) {
        self.time = time
        self.alarmLabel = alarmLabel
        self.daysToRepeat = daysToRepeat
        
    }
    
}
