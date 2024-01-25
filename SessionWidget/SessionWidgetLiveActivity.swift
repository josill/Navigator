//
//  SessionWidgetLiveActivity.swift
//  SessionWidget
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SessionWidgetLiveActivity: Widget {
//    private var locationManager = LocationManager.shared
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionAttributes.self) { context in
            VStack {
                SessionStatsWidget(context: context)
                
                SessionControlsWidget()
                    .padding(.top, 10)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
//            .activityBackgroundTint(Color(UIColor(ciColor: UIColor.systemBackground.ciColor)))
            .activityBackgroundTint(.clear)
            .activitySystemActionForegroundColor(.black)

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
