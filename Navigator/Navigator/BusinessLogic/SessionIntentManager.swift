//
//  SessionIntentManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 31.12.2023.
//

import Foundation

class SessionIntentManager: ObservableObject {
    private var locationManager = LocationManager.shared
    private var sessionData = SessionData.shared
    
    func addCheckpoint() {
        locationManager.addCheckpoint()
    }

    func addWaypoint() {
        locationManager.addWaypoint()
    }

    func startOrStopSession() {
        locationManager.startOrStopSession()
    }

    func quitSession() {
        sessionData.sessionQuitAlertPresented.toggle()
    }
}
