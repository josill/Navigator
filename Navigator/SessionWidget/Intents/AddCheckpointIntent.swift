//
//  AddCheckpointIntent.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

struct AddCheckpointIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"

    func perform() async throws -> some IntentResult {
        Task { @MainActor in
            SessionIntentManager().addCheckpoint()
        }
        return .result()
    }
}
