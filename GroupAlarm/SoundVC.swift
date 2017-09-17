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
import Firebase
import FirebaseDatabase

class SoundVC: UITableViewController {
    
    var cellTapSound: AVAudioPlayer?
    var soundSelected: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sounds"
    }
    
    var player: AVAudioPlayer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.tag == 0){
            cellTapSound?.stop()
            cellTapSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Spaceship_Alarm", withExtension: "mp3")!)
            cellTapSound?.prepareToPlay()
            if (cellTapSound?.isPlaying)! {
                cellTapSound?.currentTime = 0.0
            }
            cellTapSound?.play()
            
            soundSelected = "Spaceship_Alarm"
        }
        if(tableView.cellForRow(at: indexPath)?.tag == 1){
            cellTapSound?.stop()
            cellTapSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Digital_Alarm", withExtension: "mp3")!)
            cellTapSound?.prepareToPlay()
            if (cellTapSound?.isPlaying)! {
                cellTapSound?.currentTime = 0.0
            }
            cellTapSound?.play()
            
            soundSelected = "Digital_Alarm"
        }
        if(tableView.cellForRow(at: indexPath)?.tag == 2){
            cellTapSound?.stop()
            cellTapSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Bell_Alarm", withExtension: "mp3")!)
            cellTapSound?.prepareToPlay()
            if (cellTapSound?.isPlaying)! {
                cellTapSound?.currentTime = 0.0
            }
            cellTapSound?.play()
            
            soundSelected = "Bell_Alarm"
        }
        if(tableView.cellForRow(at: indexPath)?.tag == 3){
            cellTapSound?.stop()
            cellTapSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Dog_Barking_Alarm", withExtension: "mp3")!)
            cellTapSound?.prepareToPlay()
            if (cellTapSound?.isPlaying)! {
                cellTapSound?.currentTime = 0.0
            }
            cellTapSound?.play()
            
            soundSelected = "Dog_Barking_Alarm"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "unwindFromSound") {
            let destination = segue.destination as! AlarmInformation
            
            if(self.soundSelected == nil) {
                destination.selectedSound = "Digital_Alarm"
            }
            else {
                destination.selectedSound = self.soundSelected
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cellTapSound?.stop()
    }
}
