//
//  ViewController.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/10/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gettingStartedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gettingStartedView.layer.cornerRadius = 8
        gettingStartedView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
