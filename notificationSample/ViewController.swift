//
//  ViewController.swift
//  notificationSample
//
//  Created by 林克彦 on 2018/10/05.
//  Copyright © 2018年 Katsuhiko Hayashi. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 日付フォーマット
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        // 日時指定通知のボタン作成
        let buttonCalendar = UIButton()
        buttonCalendar.frame = CGRect(x:10, y:40, width:200, height:50)
        buttonCalendar.setTitle("日時指定通知", for:UIControl.State.normal)
        buttonCalendar.backgroundColor = UIColor.red
        buttonCalendar.addTarget(self,
                                 action: #selector(ViewController.buttonCalendarTouchUpInside(sender:)),
                                 for: .touchUpInside)
        self.view.addSubview(buttonCalendar)
        
        // タイマー通知のボタン作成
        let buttonTimer = UIButton()
        buttonTimer.frame = CGRect(x:10, y:100, width:200, height:50)
        buttonTimer.setTitle("タイマー通知", for:UIControl.State.normal)
        buttonTimer.backgroundColor = UIColor.blue
        buttonTimer.addTarget(self,
                              action: #selector(ViewController.buttonTimerTouchUpInside(sender:)),
                              for: .touchUpInside)
        self.view.addSubview(buttonTimer)
        
        // 実行待ち通知一覧
        let buttonPendingList = UIButton()
        buttonPendingList.frame = CGRect(x:10, y:160, width:200, height:50)
        buttonPendingList.setTitle("実行待ち通知一覧", for:UIControl.State.normal)
        buttonPendingList.backgroundColor = UIColor.orange
        buttonPendingList.addTarget(self,
                                    action: #selector(ViewController.buttonPendingListTouchUpInside(sender:)),
                                    for: .touchUpInside)
        self.view.addSubview(buttonPendingList)
        
        // 実行済み通知一覧
        let buttonDeliveredList = UIButton()
        buttonDeliveredList.frame = CGRect(x:10, y:220, width:200, height:50)
        buttonDeliveredList.setTitle("実行済み通知一覧", for:UIControl.State.normal)
        buttonDeliveredList.backgroundColor = UIColor.purple
        buttonDeliveredList.addTarget(self,
                                      action: #selector(ViewController.buttonDeliveredListTouchUpInside(sender:)),
                                      for: .touchUpInside)
        self.view.addSubview(buttonDeliveredList)
    }

    @objc func buttonCalendarTouchUpInside(sender : UIButton) {
        print("buttonCalendarTouchUpInside")
        // ローカル通知のの内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "ローカル通知テスト"
        content.subtitle = "日時指定"
        content.body = "日時指定によるタイマー通知です"
        
        // ローカル通知実行日時をセット（5分後)
        let date = Date()
        let newDate = Date(timeInterval: 5*60, since: date)
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDate)
        
        // ローカル通知リクエストを作成
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // ユニークなIDを作る
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func buttonTimerTouchUpInside(sender : UIButton) {
        print("buttonTimerTouchUpInside")
        
        // ローカル通知のの内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "ローカル通知テスト"
        content.subtitle = "タイマー通知"
        content.body = "タイマーによるローカル通知です"
        
        // タイマーの時間（秒）をセット
        let timer = 10
        // ローカル通知リクエストを作成
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timer), repeats: false)
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func buttonPendingListTouchUpInside(sender : UIButton) {
        print("<Pending request identifiers>")
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("identifier:\(request.identifier)")
                print("  title:\(request.content.title)")
                
                if request.trigger is UNCalendarNotificationTrigger {
                    let trigger = request.trigger as! UNCalendarNotificationTrigger
                    print("  <CalendarNotification>")
                    let components = DateComponents(calendar: Calendar.current, year: trigger.dateComponents.year, month: trigger.dateComponents.month, day: trigger.dateComponents.day, hour: trigger.dateComponents.hour, minute: trigger.dateComponents.minute)
                    print("    Scheduled Date:\(self.dateFormatter.string(from: components.date!))")
                    print("    Reperts:\(trigger.repeats)")
                    
                } else if request.trigger is UNTimeIntervalNotificationTrigger {
                    let trigger = request.trigger as! UNTimeIntervalNotificationTrigger
                    print("  <TimeIntervalNotification>")
                    print("    TimeInterval:\(trigger.timeInterval)")
                    print("    Reperts:\(trigger.repeats)")
                }
                print("----------------")
            }
        }
    }
    
    @objc func buttonDeliveredListTouchUpInside(sender : UIButton) {
        print("<Delivered request identifiers>")
        
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications: [UNNotification]) in
            for notification in notifications {
                print("identifier:\(notification.request.identifier)")
                print("  title:\(notification.request.content.title)")
                
                if notification.request.trigger is UNCalendarNotificationTrigger {
                    let trigger = notification.request.trigger as! UNCalendarNotificationTrigger
                    print("  <CalendarNotification>")
                    let components = DateComponents(calendar: Calendar.current, year: trigger.dateComponents.year, month: trigger.dateComponents.month, day: trigger.dateComponents.day, hour: trigger.dateComponents.hour, minute: trigger.dateComponents.minute)
                    print("    Scheduled Date:\(self.dateFormatter.string(from: components.date!))")
                    print("    Reperts:\(trigger.repeats)")
                    
                } else if notification.request.trigger is UNTimeIntervalNotificationTrigger {
                    let trigger = notification.request.trigger as! UNTimeIntervalNotificationTrigger
                    print("  <TimeIntervalNotification>")
                    print("    TimeInterval:\(trigger.timeInterval)")
                    print("    Reperts:\(trigger.repeats)")
                }
                print("----------------")
            }
        }
    }
}

