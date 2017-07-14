//
//  SoundVC.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/13/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SoundVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sounds"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.tag == 0){
            
            let systemSoundID: SystemSoundID = 1304
            
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
}
