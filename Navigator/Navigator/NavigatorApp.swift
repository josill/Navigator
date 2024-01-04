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
    @StateObject var locationManager = LocationManager()
    @StateObject var notificationManager = NotificationManager()
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(router)
        }
        .modelContainer(for: [Location.self, Session.self])
    }
}
