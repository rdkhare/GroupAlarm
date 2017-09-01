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


class DisplayAlarms: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    //    var daily: Bool? = false
    
    var dateA: Date?
    
    var time: String?
    
    var createdBy: String?
    
    var alarmKeys = [String]()
    
    var currentUsername: String?
    
    var weekdaysChecked = [String]()
    let dispatchGroup = DispatchGroup()

    var sendDays = [String]()
    var player: AVAudioPlayer?
    var newAlarms = [Alarm]()

    var alarms = [Alarm]() {
        didSet {
            alarmTitleCrap()
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
    
    func alarmTitleCrap() {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        emptyLabel.textColor = UIColor.white
        emptyLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightThin)
        emptyLabel.textAlignment = NSTextAlignment.center
        if(alarms.isEmpty == true) {
            
            emptyLabel.text = "Add an alarm!"
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
            
        else{
            emptyLabel.text = ""
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
        
    }
    
    override func viewDidLoad() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (didAllow, error) in
            
            if(!didAllow) {
                print("User does not want notifications")
                
                let alertA = UIAlertController(title: "Turn on Notifications", message: "Notifications must be turned on in order for this app to function preoperly.", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                alertA.addAction(UIAlertAction(title: "Turn On.", style: UIAlertActionStyle.default, handler: { action in
                    
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    
                    
                }))
                
                alertA.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alertA, animated: true, completion: nil)
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
                        
                        let shareAlarmRef = ref.child("users").child(currentUserID!).child("alarmID")
                        
                        shareAlarmRef.updateChildValues([check.key: true])
                        
                        self.tableView.reloadData()
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
            }

        })
        
        ref.child("users").child(currentUserID!).child("alarmID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let alarmIDEnumerator = snapshot.children
            self.newAlarms = []

            while let alarmIDs = alarmIDEnumerator.nextObject() as? DataSnapshot {
                
                if(alarmIDs.value as! Bool == true) {
                    self.dispatchGroup.enter()
                    ref.child("alarms").child("\(alarmIDs.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get alarm values for current user
                        let value = snapshot.value as? NSDictionary
                        let alarmtime = value?["alarmTime"] as? String ?? ""
                        let alarmlabel = value?["alarmLabel"] as? String ?? ""
                        let createdBy = value?["createdBy"] as? String ?? ""
                        //make alarm object and append to alarm
                        let repeatDays = value?["repeatedDays"] as? NSArray ?? [String]() as NSArray
                        let members = value?["userID"] as? NSArray ?? [String]() as NSArray

                        alarmIDValue = alarmIDs.key

                        
                        let alarm = Alarm.init(time: alarmtime, alarmLabel: alarmlabel, daysToRepeat: (repeatDays as? [String])!)
                        
                        alarm.members = members as! [String]
                        alarm.key = alarmIDValue!

                        alarm.createdBy = createdBy
                        
                        self.newAlarms.append(alarm)
                        
                        self.dispatchGroup.leave()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            self.dispatchGroup.notify(queue: .main, execute: {
                self.alarms = self.newAlarms
                self.tableView.reloadData()
            })
            
        })
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count

    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func unwindToAlarmController(_ segue: UIStoryboardSegue){
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
                        
                        let shareAlarmRef = ref.child("users").child(currentUserID!).child("alarmID")
                        
                        shareAlarmRef.updateChildValues([check.key: true])
                        
                        self.tableView.reloadData()
                        
                    }))
                    
                    
                    alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
            }
            self.tableView.reloadData()
            
        })
        
        ref.child("users").child(currentUserID!).child("alarmID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let alarmIDEnumerator = snapshot.children
            self.newAlarms = []
            
            while let alarmIDs = alarmIDEnumerator.nextObject() as? DataSnapshot {
                
                if(alarmIDs.value as! Bool == true) {
                    
                    self.dispatchGroup.enter()
                    ref.child("alarms").child("\(alarmIDs.key)").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get alarm values for current user
                        let value = snapshot.value as? NSDictionary
                        let alarmtime = value?["alarmTime"] as? String ?? ""
                        let alarmlabel = value?["alarmLabel"] as? String ?? ""
                        let createdBy = value?["createdBy"] as? String ?? ""
                        //make alarm object and append to alarm
                        let repeatDays = value?["repeatedDays"] as? NSArray ?? [String]() as NSArray
                        let members = value?["userID"] as? NSArray ?? [String]() as NSArray
                        
                        alarmIDValue = alarmIDs.key

                        
                        let alarm = Alarm.init(time: alarmtime, alarmLabel: alarmlabel, daysToRepeat: (repeatDays as? [String])!)
                        
                        alarm.members = members as! [String]
                        alarm.key = alarmIDValue!
                        
                        alarm.createdBy = createdBy
                        
                        self.newAlarms.append(alarm)
                        self.dispatchGroup.leave()
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            
            self.dispatchGroup.notify(queue: .main, execute: { 
                self.alarms = self.newAlarms
                self.tableView.reloadData()
            })
        })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! DisplayAlarmCell
        
        cell.selectionStyle = .none
        
        let row = indexPath.row
        let alarm = alarms[row]
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date)
        
        //only up to 40 alarms on free version lol
        if(alarms.count == 40) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            tableView.reloadData()
        }
        
        //cell's alarm text and clock text
        cell.alarmTitle.text = alarm.alarmLabel
        cell.clockTitle.text = alarm.time
        cell.alarmCreated.text = alarm.createdBy
        
        var refA: DatabaseReference
        refA = Database.database().reference()
        
        refA.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.currentUsername = value?["username"] as? String
            
        })
        
        if(self.dateA != nil) {
            if(self.weekdaysChecked.isEmpty) {
                
                let application = UIApplication.shared
                
                if (application.applicationState == UIApplicationState.active || application.applicationState == UIApplicationState.inactive) {
                    
                    //in here
                    self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: self.dateA!, identifier: "OwnerNeverNotif")
                }
                    
                else {
                    
                    //in here
                    self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: self.dateA!, identifier: "OwnerNeverNotif")
                }
            }
        }
        
        for weekdays in self.weekdaysChecked {
            
            if(dayInWeek == weekdays){
                
                let application = UIApplication.shared
                if (application.applicationState == UIApplicationState.active) {
                    
                    //in here
                    
                    self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: self.dateA!, identifier: "OwnerDayNotif")
                    
                }
                    
                else {
                    
                    //in here
                    self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: self.dateA!, identifier: "OwnerDayNotif")
                }
            }
        }
        
        refA.child("alarms").child(alarm.key!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if(!snapshot.exists()) {
                refA.child("users").child((Auth.auth().currentUser?.uid)!).child("alarmID").child(alarm.key!).removeValue()
            }
            
            else {
                
                let value = snapshot.value as? NSDictionary
                
                self.time = value?["alarmTime"] as? String
                let dateFormatterA = DateFormatter()
                dateFormatterA.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                
                let timeDate = dateFormatterA.date(from: self.time!)
                
                
                
                for weekdays in self.weekdaysChecked {
                    
                    if(dayInWeek == weekdays){
                        
                        let application = UIApplication.shared
                        if (application.applicationState == UIApplicationState.active) {
                            
                            //in here
                            
                            self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: timeDate!, identifier: "DayNotification")
                        }
                            
                        else {
                            
                            //in here
                            self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: timeDate!, identifier: "DayNotification")
                        }
                    }
                }
                
                
                
                if(timeDate != nil) {
                    
                    if(self.weekdaysChecked.isEmpty) {
                        
                        let application = UIApplication.shared
                        
                        if (application.applicationState == UIApplicationState.active || application.applicationState == UIApplicationState.inactive) {
                            
                            //in here
                            self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: timeDate!, identifier: "NeverNotification")
                        }
                            
                        else {
                            
                            //in here
                            self.triggerNotification(title: alarm.alarmLabel!, body: alarm.time!, trigger: timeDate!, identifier: "NeverNotification")
                        }
                    }
                }
            }
        })
            
        
        return cell
        

    }
    
    
    func triggerNotification(title: String, body: String, trigger: Date, identifier: String) {
        
        let contentA = UNMutableNotificationContent()
        contentA.title = title
        contentA.body = body
        contentA.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
        
        let triggerTimeA = Calendar.current.dateComponents([.hour,.minute], from: trigger)
        let triggerA = UNCalendarNotificationTrigger(dateMatching: triggerTimeA, repeats: true)
        let identifierA = identifier
        let requestA = UNNotificationRequest(identifier: identifierA, content: contentA, trigger: triggerA)
        UNUserNotificationCenter.current().add(requestA, withCompletionHandler: nil)
        
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
    
    func deleteFromDatabase(removeValue: String) {

        

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            var ref: DatabaseReference
            
            let alarmToDelete = self.alarms[indexPath.row].key!
            ref = Database.database().reference().child("alarms").child(alarmToDelete).child("userID")
            
            var refA: DatabaseReference
            refA = Database.database().reference()
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                    
                let sharedTrue = value?["1"] as? String
                
                if(sharedTrue != nil) {
                    refA.child("users").child((Auth.auth().currentUser?.uid)!).child("alarmID").child(alarmToDelete).removeValue()
                }
                    
                else {
                    refA.child("alarms").child(alarmToDelete).removeValue()
                    refA.child("users").child((Auth.auth().currentUser?.uid)!).child("alarmID").child(alarmToDelete).removeValue()
                }
                
            })
            
//            deleteFromDatabase(removeValue: "\(alarms[indexPath.row].key!)")

            self.alarms.remove(at: indexPath.row)
            
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

