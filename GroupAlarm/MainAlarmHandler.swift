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

class MainAlarmHandler: UIViewController, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
//    var daily: Bool? = false    
    var dateA: Date? = nil
    
    var weekdaysChecked = [String]()
    
    var alarms = [Alarm]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (didAllow, error) in
            
            if(error != nil) {
                print("User does not want notifications")
            }
            
        })
        
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference
        
        ref = Database.database().reference()
        
        ref.child("alarms").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get alarm values for current user
            let value = snapshot.value as? NSDictionary
            let alarmtime = value?["alarmTime"] as? String ?? ""
            let alarmlabel = value?["alarmLabel"] as? String ?? ""
            
            
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: alarms[]) as! DisplayAlarmCell
            
            cell.alarmTitle.text = alarmlabel
            cell.clockTitle.text = alarmtime
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        postRef.updateChildValues(dict)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func unwindToAlarmController(_ segue: UIStoryboardSegue){
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! DisplayAlarmCell
        
        let row = indexPath.row
        let alarm = alarms[row]
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date)
        
        
        if(alarms.count == 40) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            tableView.reloadData()
        }
        
        cell.alarmTitle.text = alarm.alarmLabel
        cell.clockTitle.text = alarm.time
        
        print(weekdaysChecked)
        
        for weekdays in weekdaysChecked {
            if(dayInWeek == weekdays){
                let content = UNMutableNotificationContent()
                content.title = alarm.alarmLabel!
                content.body = alarm.time!
                content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let identifier = "UYLLocalNotification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                
                print("This is the correct day.")
            }
        }

        
//        if(daily == nil){
//            daily = false
//        }
//        
//        if(daily == true){
//            let content = UNMutableNotificationContent()
//            content.title = alarm.alarmLabel!
//            content.body = alarm.time!
//            
//            content.sound = UNNotificationSound(named: "Spaceship_Alarm.mp3")
//            
//            let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: dateA!)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
//            
//            let identifier = "UYLLocalNotification"
//            
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//            
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            
//            print("This is working")
//            
//        }
//        
//        print("\(daily!) is the result for everyday")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.alarms.remove(at: indexPath.row)
            
            
            
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

