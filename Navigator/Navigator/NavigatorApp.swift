//
//  NavigatorApp.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI
import SwiftData

@main
struct NavigatorApp: App {
    @StateObject var dbService = DatabaseService.shared
    @StateObject var locationManager = LocationManager()
    @StateObject var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dbService)
                .environmentObject(locationManager)
                .environmentObject(notificationManager)
        }
        .modelContainer(for: User.self)
    }
}
