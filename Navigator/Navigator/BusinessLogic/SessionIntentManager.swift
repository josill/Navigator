//
//  SessionIntentManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 31.12.2023.
//

import Foundation

class SessionIntentManager: ObservableObject {
    private var locationManager = LocationManager.shared
    
    
    func addCheckpoint() {
        locationManager.addCheckpoint()
        print("Hello from addCheckpoint()")
    }

    func addWaypoint() {
        locationManager.addWaypoint()
        print("Hello from addWaypoint()")
    }

    func startOrStopSession() {
        locationManager.startOrStopSession()
        print("Hello from toggleSessionState()")
    }

    func quitSession() {
        print("Hello from endSession()")
    }
}
