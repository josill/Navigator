//
//  NotificationHandler.swift
//  Navigator
//
//  Created by Jonathan Sillak on 26.11.2023.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        
        self.changeAuthorizationStatus()
        print("Authorization Status: \(self.authorizationStatus.rawValue)")   
    }
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("access granted")
                print(self.authorizationStatus)
            } else if let error {
                print(error.localizedDescription)
            }
            
            self.changeAuthorizationStatus()
        }
    }
    
    func changeAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
                print("Authorization Status: \(self.authorizationStatus.rawValue)")
            }
        }
    }
    
    func sendNotification(timeInterval: Double = 10, title: String, body: String) {
        print("sendNotification")
        print(authorizationStatus)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
