//
//  SessionLink.swift
//  Navigator
//
//  Created by Jonathan Sillak on 02.12.2023.
//

import SwiftUI

struct SessionLink: View {
    var session: Session
    
    var body: some View {
        NavigationLink(destination: MapView()) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(session.sessionName)")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Created at: \(formatDateString(session.createdAt))")
                        .foregroundColor(.white)
                    Text("Distance covered: \(String(format: "%.2f", session.distanceCovered))")
                        .foregroundColor(.white)
                    Text("Time elapsed: \(session.timeElapsed)")
                        .foregroundColor(.white)
                    Text("Average speed: \(String(format: "%.2f", session.averageSpeed))")
                        .foregroundColor(.white)
                }
                .padding(10)
            }
        .background(.black)
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.blue)
    }
    
    func formatDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy 'at' h:mm a"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SessionLink(session: Session(sessionId: UUID(), userId: UUID(), sessionName: "Sample Session", createdAt: Date(), distanceCovered: 10.5, timeElapsed: 3600, averageSpeed: 5.0, checkPoints: [], wayPoints: [], locations: []))
}
