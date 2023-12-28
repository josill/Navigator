//
//  SessionWidgetLiveActivity.swift
//  SessionWidget
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct SessionAttributes: ActivityAttributes {
    public struct ContentState: Codable & Hashable {
        let sessionDistance: Double
        let sessionDuration: String
        let sessionSpeed: Double
    }
}

import ActivityKit
import WidgetKit
import SwiftUI
//public struct SessionAttributes: ActivityAttributes {
//    public struct ContentState: Codable & Hashable {
//        let sessionDistance: Double
//        let sessionDuration: String
//        let sessionSpeed: Double
//    }
//}

struct SessionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.sessionDuration)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.sessionDuration)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.sessionDuration)")
            } minimal: {
                Text(context.state.sessionDuration)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    func requestActivity() {
        let session = SessionAttributes()
        let initialState = SessionAttributes.ContentState(
            sessionDistance: 0.0,
            sessionDuration: "00:00:00",
            sessionSpeed: 0.0
        )
        
        let content = ActivityContent(state: initialState, staleDate: nil)
        
        let _ = try? Activity.request(
            attributes: session,
            content: content,
            pushType: nil
        )
    }
    
    func updateActivity(
        activity: Activity<SessionAttributes>,
        distance: Double,
        duration: String,
        speed: Double
    ) async {
        let contentState = SessionAttributes.ContentState(
            sessionDistance: distance,
            sessionDuration: duration,
            sessionSpeed: speed
        )
        
        var alertConfig = AlertConfiguration(
            title: "Session has been updated!",
            body: "Open the app to view the session",
            sound: .default
        )
        
        await activity.update(
            ActivityContent<SessionAttributes.ContentState>(
                state: contentState,
                staleDate: nil
            ),
            alertConfiguration: alertConfig
        )
    }
    
    func endActivity(
        activity: Activity<SessionAttributes>,
        distance: Double,
        duration: String,
        speed: Double
    ) async {
        let finalContent = SessionAttributes.ContentState(
            sessionDistance: distance,
            sessionDuration: duration,
            sessionSpeed: speed
        )
        
        await activity.end(
            ActivityContent(state: finalContent, staleDate: nil),
            dismissalPolicy: .default
        )
    }
}

extension SessionAttributes {
    fileprivate static var preview: SessionAttributes {
        SessionAttributes()
    }
}

extension SessionAttributes.ContentState {
    fileprivate static var smiley: SessionAttributes.ContentState {
        SessionAttributes.ContentState(
            sessionDistance: 0,
            sessionDuration: "0",
            sessionSpeed: 0
        )
     }
}

#Preview("Notification", as: .content, using: SessionAttributes.preview) {
    SessionWidgetLiveActivity()
} contentStates: {
    SessionAttributes.ContentState.smiley
}
