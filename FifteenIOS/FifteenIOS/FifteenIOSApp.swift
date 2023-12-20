//
//  FifteenIOSApp.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

@main
struct FifteenIOSApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
