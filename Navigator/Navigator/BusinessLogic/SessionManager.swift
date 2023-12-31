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
    
    private var activity: Activity<SessionAttributes>? // We only allow one activity at a time because we can only create one session at a time
    
    func startActivity(state contentState: SessionAttributes.ContentState? = nil) {
        do {
            guard activity == nil else {
                return
            }
            
            let session = SessionAttributes()
            let initialState = SessionAttributes.ContentState(
                sessionDistance: contentState?.sessionDistance ?? 0.0,
                sessionDuration: contentState?.sessionDuration ?? "00:00:00",
                sessionSpeed: contentState?.sessionSpeed ?? 0.0
            )
            
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            activity = try Activity.request(
                attributes: session,
                content: content,
                pushType: nil
            )
        } catch (let e) {
            print("SessionManager startActivity() failed! Error:")
            print(e.localizedDescription)
        }
    }
    
    func getActivity() -> Activity<SessionAttributes>? {
        if let activity = activity {
            return activity
        }
        
        return nil
    }
    
    func updateActivity(
        distance: Double,
        duration: String,
        speed: Double
    ) {
        if let activity = activity {
            let contentState = SessionAttributes.ContentState(
                sessionDistance: distance,
                sessionDuration: duration,
                sessionSpeed: speed
            )
            
            Task {
                await activity.update(
                    ActivityContent<SessionAttributes.ContentState>(
                        state: contentState,
                        staleDate: nil
                    )
                )
            }
        }
    }

    func stopActivity() {
        if let activity = activity {
            Task {
                await activity.end(nil, dismissalPolicy: .default)
            }
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
        locationManager.startOrStopSession()
        print("Hello from toggleSessionState()")
    }
    
    func quitSession() {
        print("Hello from endSession()")
    }
}

//@available(iOS 17.0, *)
//extension SessionManager: @unchecked Sendable {}
