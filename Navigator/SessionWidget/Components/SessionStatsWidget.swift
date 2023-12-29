//
//  SessionStatsWidget.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct SessionStatsWidget: View {
//    @Environment(\.colorScheme) var colorScheme
//    var locationManager = LocationManager()
    var context: ActivityViewContext<SessionAttributes>

    var body: some View {
        VStack(spacing: 8) {
            Text("Distance covered: \(String(format: "%.2f", context.state.sessionDistance)) m")
                .font(.subheadline)
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

            Text("Session duration: \(context.state.sessionDuration)")
                .font(.subheadline)
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

            Text("Average speed: \(String(format: "%.2f", context.state.sessionSpeed)) km/h")
                .font(.subheadline)
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

        }
        .padding()
//        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

//#Preview {
//    SessionStatsWidget()
//}
