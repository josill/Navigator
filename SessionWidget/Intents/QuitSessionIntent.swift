//
//  QuitSessionIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

struct QuitSessionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
    
    func perform() async throws -> some IntentResult {
//        SessionIntentManager().quitSession()
        
        return .result()
    }
}
