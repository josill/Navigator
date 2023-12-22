//
//  gpsmapdemo23fApp.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import SwiftUI

@main
struct gpsmapdemo23fApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationViewModel())
        }
    }
}
