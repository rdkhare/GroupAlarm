//
//  AlarmRing.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 8/7/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AlarmRing: UIViewController {
    
    @IBOutlet weak var alarmRingImage: UIImageView!
    @IBOutlet weak var alarmTitle: UILabel!
    @IBOutlet weak var alarmRing: UILabel!
    
    var alarm: Alarm?
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        
        alarmTitle.text = alarm?.alarmLabel
        alarmRing.text = alarm?.time
        
        playSound()
        shake()
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
    
    func stopSound() {
        guard let url = Bundle.main.url(forResource: "Spaceship_Alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(false)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.stop()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        alarmRingImage.layer.add(animation, forKey: "shake")
    }
    
    @IBAction func dismissController(_ sender: Any) {
        
        stopSound()
        
        self.performSegue(withIdentifier: "unwindToAlarm", sender: sender)
    }
    override func didReceiveMemoryWarning() {
        
    }
    
}
