//
//  NotificationHandler.swift
//  Navigator
//
//  Created by Jonathan Sillak on 26.11.2023.
//

import Foundation
import SwiftUI
import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject {
    @Published var notificationsAllowed = false // allowed by system
    @Published var notificationsEnabled = true // user wants to get updates
    
    private var timer: Timer?

    static let shared = NotificationManager()
    
    override init() {
        super.init()
        
        self.changeAuthorizationStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { self.startSendingNotifications() }
            
            self.changeAuthorizationStatus()
        }
    }
    
    func changeAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsAllowed = settings.authorizationStatus.rawValue == 2 ? true : false
            }
        }
    }
    
    func changeNotificationsEnabled() {
        self.notificationsEnabled = !self.notificationsEnabled
        
        if self.notificationsEnabled { startSendingNotifications() }
        else { stopSendingNotifications() }
    }
    
    func startSendingNotifications() {
        guard notificationsEnabled else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let body = """
            Total distance covered: TODO km
            Time elapsed: TODO
            Average speed: TODO km/h
            """
            
            self.sendNotification(title: "Your session", body: body)
        }

        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopSendingNotifications() {
        timer?.invalidate()
        timer = nil
    }
    
    func sendNotification(timeInterval: Double = 10, title: String, body: String) {
        print("sendNotification")
        print("notifications allowed: \(notificationsAllowed)")

        let id = "1"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    @objc func appDidEnterBackground() {
        stopSendingNotifications()
    }

    @objc func appWillEnterForeground() {
        startSendingNotifications()
    }
}
