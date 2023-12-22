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
    
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(for: User.self, UserLocation.self, Session.self)
                dbService.setContext(modelContainer: modelContainer)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dbService)
                .environmentObject(locationManager)
                .environmentObject(notificationManager)
        }
        .modelContainer(modelContainer)
    }
    
    func handleSetup(result: Result<ModelContainer, Error>) {
        switch result {
        case .success(let modelContainer):
            DispatchQueue.main.async {
                self.dbService.setContext(modelContainer: modelContainer)
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
}
