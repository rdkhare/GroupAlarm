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
import AudioToolbox

class SoundVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sounds"
    }
    
    var player: AVAudioPlayer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.tag == 0){
            
//            playSound()
            
        }
        if(tableView.cellForRow(at: indexPath)?.tag == 1){
            
            let systemSoundID: SystemSoundID = 1034
            
            AudioServicesPlaySystemSound (systemSoundID)
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Spaceship_Alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
