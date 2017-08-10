//
//  MainAlarmHandler.swift
//  GroupAlarm
//
//  Created by Taruna Arora on 7/11/17.
//  Copyright © 2017 RDKhare. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AVFoundation
import FirebaseDatabase
import Firebase
import BRYXBanner

class DisplayAlarms: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    //    var daily: Bool? = false
    
    var dateA: Date?
    
    var createdBy: String?
    
    var alarmKeys = [String]()
    
    var weekdaysChecked = [String]()
    
    var sendDays = [String]()
    var player: AVAudioPlayer?
    var alarms = [Alarm]() {
        didSet {
            tableView.reloadData()
        }
    }
    let state = UIApplication.shared.applicationState

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if(identifier == "displayAlarm") {
                
                let destinationNavigationController = segue.destination as! UINavigationController
                let targetController = destinationNavigationController.topViewController as! AlarmInformation
                
                let alarmToSelect = alarms[(self.tableView.indexPathForSelectedRow?.row)!]
                
                targetController.alarm = alarmToSelect
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (didAllow, error) in
            
            if(error != nil) {
                print("User does not want notifications")
            }
            
        })
        
        
        
        var ref: DatabaseReference
        
        ref = Database.database().reference()
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        var alarmIDValue: String?
        
        ref.child("users").child(currentUserID!).child("alarmID").observe(.value, with: { (snapshot) in
            
            guard let snap = snapshot.value as? [String : Bool] else {
                
                return
            }
            
            for check in snap {
                if(check.value == false) {
                    let alert = UIAlertController(title: "Request to share", message: "A user has requested to share an alarm with you.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { action in
                        
                        let shareAlarmRef = ref.child("users").child("alarmID").child(currentUserID)
                        
                        shareAlarmRef.updateChildValues([check.key: true])
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
            }
            
        })
        
        ref.child("users").child(currentUserID!).child("alarmID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let alarmIDEnumerator = snapshot.children
            
            while let alarmIDs = alarmIDEnumerator.nextObject() as? DataSnapshot {
                
                alarmIDValue = alarmIDs.key as String?
                
                ref.child("alarms").child(alarmIDValue!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get alarm values for current user
                    let value = snapshot.value as? NSDictionary
                    let alarmtime = value?["alarmTime"] as? String ?? ""
                    let alarmlabel = value?["alarmLabel"] as? String ?? ""
                    //make alarm object and append to alarm
                    let repeatDays = value?["repeatedDays"] as? NSArray ?? [String]() as NSArray
                    
                    let alarm = Alarm.init(time: alarmtime, alarmLabel: alarmlabel, daysToRepeat: (repeatDays as? [String])!)
                    
                    alarm.key = alarmIDValue!
                    
                    alarm.time = alarmtime
                    alarm.alarmLabel = alarmlabel
                    
                    self.alarms.append(alarm)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
        })
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        emptyLabel.textColor = UIColor.white
        emptyLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin)
        emptyLabel.textAlignment = NSTextAlignment.center
        if(alarms.isEmpty == true) {
            
            emptyLabel.text = "Add an alarm!"
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }
        
        else{
            emptyLabel.text = ""
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return alarms.count
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func unwindToAlarmController(_ segue: UIStoryboardSegue){
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! DisplayAlarmCell
        
        let row = indexPath.row
        let alarm = alarms[row]
        
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date)
        
        //only up to 40 alarms on free version lol
        if(alarms.count == 40) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            tableView.reloadData()
        }
        
        let onColor  = UIColor(red: CGFloat(99.0/255.0), green: CGFloat(125.0 / 255.0), blue: CGFloat(219.0/255.0), alpha: CGFloat(1.0))
        
        //cell's alarm text and clock text
        cell.alarmTitle.text = alarm.alarmLabel
        cell.clockTitle.text = alarm.time
        cell.enableAlarm.isOn = true
        cell.enableAlarm.onTintColor = onColor
        
        
        //checkmarks in repeated days
        for weekdays in weekdaysChecked {
            
            if(dayInWeek == weekdays){
                
                if(state == .active || state == .inactive) {
                    
//                    let time = Calendar.current.dateComponents([.hour, .minute], from: dateA!)
                    let date = Date()
//                    let currentTime = Calendar.current.dateComponents([.hour, .minute], from: date)
                    
                    if(self.dateA! == date) {
                        
                        let banner = Banner(title: alarm.alarmLabel!, subtitle: alarm.time!, image: UIImage(named: "alarmRing"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                        
                        banner.dismissesOnTap = true
                        banner.show(duration: 30.0)
                        
                        
                        if(banner.dismissesOnTap == true) {
                            stopSound()
                        }
                        else {
                            playSound()
                        }
                    }
                }
                else {
                    
                    let application = UIApplication.shared
                    if (application.applicationState == UIApplicationState.active) {
                        let content = UNMutableNotificationContent()
                        content.title = alarm.alarmLabel!
                        content.body = alarm.time!
                        content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                        let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
                        let identifier = "UYLLocalNotification"
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    }
                    
                    else {
                        
                        let content = UNMutableNotificationContent()
                        content.title = alarm.alarmLabel!
                        content.body = alarm.time!
                        content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                        let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
                        let identifier = "UYLLocalNotification"
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    }
                }
            }
        }
        

        if(dateA != nil) {
            
            if(weekdaysChecked.isEmpty) {
                
                let application = UIApplication.shared

                if (application.applicationState == UIApplicationState.active || application.applicationState == UIApplicationState.inactive) {
                    let content = UNMutableNotificationContent()
                    content.title = alarm.alarmLabel!
                    content.body = alarm.time!
                    content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                    let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
                    let identifier = "UYLLocalNotification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
                
                else {
                    
                    let content = UNMutableNotificationContent()
                    content.title = alarm.alarmLabel!
                    content.body = alarm.time!
                    content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                    let triggerTime = Calendar.current.dateComponents([.hour,.minute], from: self.dateA!)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
                    let identifier = "NeverNotification"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
            
            if(alarm.key != nil) {
                
                ref.child("alarms").child(alarm.key!).child("userID").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let userIDKeys = snapshot.children
                    
                    while let userIDKey = userIDKeys.nextObject() as? DataSnapshot {
                        if(userIDKey.key == "0") {
                            ref.child("users").child(userIDKey.value as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                
                                let createdByText = value?["username"] as? String ?? ""
                                
                                print(createdByText)
                                self.createdBy = createdByText
                                cell.alarmCreated.text = "Created by \(self.createdBy!)"
                                
                            })
                        }
                    }
                    
                }) { (error) in
                    
                    
                    
                }
            }
            
        }
        
        return cell
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
    
    let firebase = Database.database().reference()
    
    func myDeleteFunction(childIWantToRemove: String) {
        let currentUserID = Auth.auth().currentUser?.uid
        
        
        firebase.child("users").child(currentUserID!).child("alarmID").child(childIWantToRemove).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.alarms.remove(at: indexPath.row)
            
            myDeleteFunction(childIWantToRemove: "\(indexPath.row)")
            
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

