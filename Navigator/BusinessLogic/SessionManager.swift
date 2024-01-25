//
//  SessionManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit

class SessionManager: ObservableObject {
    static let shared = SessionManager()
        
    private var activity: Activity<SessionAttributes>? // We only allow one activity at a time because we can only create one session at a time
    
    init(activity: Activity<SessionAttributes>? = nil) {
        self.activity = activity
    }
    
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
    
    func updateDistance(distance: Double) {
        if let activity = activity {
            let contentState = SessionAttributes.ContentState(
                sessionDistance: distance,
                sessionDuration: activity.content.state.sessionDuration,
                sessionSpeed: activity.content.state.sessionSpeed
            )
            
            updateActivity(contentState)
        }
    }

    func updateDuration(duration: String) {
        if let activity = activity {
            let contentState = SessionAttributes.ContentState(
                sessionDistance: activity.content.state.sessionDistance,
                sessionDuration: duration,
                sessionSpeed: activity.content.state.sessionSpeed
            )
            
            updateActivity(contentState)
        }
    }

    func updateSpeed(speed: Double) {
        if let activity = activity {
            let contentState = SessionAttributes.ContentState(
                sessionDistance: activity.content.state.sessionDistance,
                sessionDuration: activity.content.state.sessionDuration,
                sessionSpeed: speed
            )
            
            updateActivity(contentState)
        }
    }
    
    private func updateActivity(_ contentState: SessionAttributes.ContentState) {
        Task {
            await activity!.update(
                ActivityContent<SessionAttributes.ContentState>(
                    state: contentState,
                    staleDate: nil
                )
            )
        }
    }


    func stopActivity() {
        if let activity = activity {
            Task {
                await activity.end(nil, dismissalPolicy: .default)
            }
        }
    }
}
