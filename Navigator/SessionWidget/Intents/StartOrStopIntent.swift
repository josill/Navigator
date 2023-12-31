//
//  StartOrStopIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation

import Foundation
import ActivityKit
import AppIntents

@available(iOS 17.0, *)
struct StartOrStopIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
    private var locationManager = LocationManager.shared
    
    func perform() async throws -> some IntentResult {
        locationManager.startOrStopSession()
        
        return .result()
    }
}
