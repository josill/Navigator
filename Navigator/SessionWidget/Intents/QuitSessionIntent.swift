//
//  QuitSessionIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

@available(iOS 17.0, *)
struct QuitSessionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
    
    func perform() async throws -> some IntentResult {
        SessionManager().quitSession()
        
        return .result()
    }
}
