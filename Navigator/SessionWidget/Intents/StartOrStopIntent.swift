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

struct StartOrStopIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
    
    func perform() async throws -> some IntentResult {
        SessionIntentManager().startOrStopSession()
        
        return .result()
    }
}
