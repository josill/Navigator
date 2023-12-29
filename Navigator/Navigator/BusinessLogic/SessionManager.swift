//
//  SessionManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit

class SessionManager: ObservableObject {
    static var shared = SessionManager()
    
    private var locationManager = LocationManager.shared
    
    func startActivity(state contentState: SessionAttributes.ContentState? = nil) {
        do {
            let session = SessionAttributes()
            let initialState = SessionAttributes.ContentState(
                sessionDistance: contentState?.sessionDistance ?? 0.0,
                sessionDuration: contentState?.sessionDuration ?? "00:00:00",
                sessionSpeed: contentState?.sessionSpeed ?? 0.0
            )
            
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            let _ = try Activity.request(
                attributes: session,
                content: content,
                pushType: nil
            )
        } catch (let e) {
            print("SessionManager startActivity() failed! Error:")
            print(e.localizedDescription)
        }
    }
    
    func addCheckpoint() {
        locationManager.addCheckpoint()
        print("Hello from addCheckpoint()")
    }
    
    func addWaypoint() {
        locationManager.addWaypoint()
        print("Hello from addWaypoint()")
    }
    
    func toggleActiveState() {
        print("Hello from toggleSessionState()")
    }
    
    func quitSession() {
        print("Hello from endSession()")
    }
}

//@available(iOS 17.0, *)
//extension SessionManager: @unchecked Sendable {}
