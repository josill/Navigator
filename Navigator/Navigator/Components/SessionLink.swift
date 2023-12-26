//
//  SessionLink.swift
//  Navigator
//
//  Created by Jonathan Sillak on 02.12.2023.
//

import SwiftUI

struct SessionLink: View {
    @EnvironmentObject private var router: Router
    @State var session: Session
    
    var body: some View {
        Button {
            router.changeRoute(.init(.map))
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(session.name)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("Created at: \(formatDateString(session.recordedAt))")
                    .foregroundColor(.white)
                Text("Distance covered: \(formatDistance(session.distance)) meters")
                    .foregroundColor(.white)
                Text("Time elapsed: \(formatTime(session.duration))")
                    .foregroundColor(.white)
                Text("Average speed: \(String(format: "%.2f", session.speed))")
                    .foregroundColor(.white)
            }
            .padding(10)
            
        }
        .background(.black)
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.blue)
    }
    
    func formatDistance(_ distance: Double) -> String {
        let formattedDistance = String(format: "%.0f", distance)
        return "\(formattedDistance)"
    }
    
    func formatTime(_ duration: Double) -> String {
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formatDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        return formatter.string(from: date)
    }

    
}

//#Preview {
//    SessionLink(router: .shared, session: [])
//}
