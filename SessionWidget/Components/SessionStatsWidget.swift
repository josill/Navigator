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
        HStack(spacing: 8) {
            Image(systemName: "map")
            Text("\(String(format: "%.2f", context.state.sessionDistance)) m")
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            Image(systemName: "clock")
            Text("\(context.state.sessionDuration)")
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            Image(systemName: "figure.walk")
            Text("\(String(format: "%.2f", context.state.sessionSpeed)) km/h")
//                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

        }
        .font(.headline)
//        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

//#Preview {
//    SessionStatsWidget()
//}
