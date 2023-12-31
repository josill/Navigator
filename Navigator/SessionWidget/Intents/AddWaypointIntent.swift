//
//  AddWaypointIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

struct AddWaypointIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"

    func perform() async throws -> some IntentResult {
        SessionIntentManager().addWaypoint()
        
        return .result()
    }
}
