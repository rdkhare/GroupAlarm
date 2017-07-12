//
//  SecondVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/10/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class SecondVC : UIViewController {
    @IBOutlet weak var addAlarmView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addAlarmView.layer.cornerRadius = 8
        addAlarmView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
