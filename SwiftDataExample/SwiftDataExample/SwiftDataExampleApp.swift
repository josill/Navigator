//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by Jonathan Sillak on 04.01.2024.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExampleApp: App {
    let container: ModelContainer = {
        let schema = Schema([Session.self, UserLocation.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
