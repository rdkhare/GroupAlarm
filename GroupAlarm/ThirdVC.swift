//
//  ThirdVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/10/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit

class ThirdVC : UIViewController {
    @IBOutlet weak var addGroupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGroupView.layer.cornerRadius = 8
        addGroupView.layer.masksToBounds = true
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alarmView") as? AlarmHandler
        self.show(vc!, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
