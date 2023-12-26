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
    @StateObject var authHelper = AuthenticationHelper()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(notificationManager)
                .environmentObject(router)
                .environmentObject(authHelper)
        }
    }
}
