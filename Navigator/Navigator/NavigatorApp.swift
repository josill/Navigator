//
//  NavigatorApp.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

@main
struct NavigatorApp: App {
    @StateObject var locationManager = LocationManager()
    @StateObject var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(notificationManager)
        }
    }
}
