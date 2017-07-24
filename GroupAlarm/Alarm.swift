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
    let daysToRepeat: [String]? = nil
    let snooze: Bool = false
    var alarmLabel: String? = nil
    var time: String? = nil
    var completion = false
    
    init(time: String, alarmLabel: String) {
        self.time = time
        self.alarmLabel = alarmLabel
    }
    
}
