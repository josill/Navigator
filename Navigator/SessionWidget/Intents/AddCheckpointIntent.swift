//
//  AddCheckpointIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

@available(iOS 17.0, *)
struct AddCheckpointIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
//    private var sessionManager = SessionManager.shared
    
    func perform() async throws -> some IntentResult {
        print("perform in AddCheckpointIntent")
//        sessionManager.helloWorld()
        SessionManager().addCheckpoint()
        
        return .result()
    }
}
