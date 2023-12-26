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
                    Text("\(session.name)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("Created at: \(formatDateString(session.recordedAt))")
                        .foregroundColor(.white)
                    Text("Distance covered: \(String(format: "%.2f", session.distance))")
                        .foregroundColor(.white)
                    Text("Time elapsed: \(session.duration)")
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
    
    func formatDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy 'at' h:mm a"
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    SessionLink(session: Session(id: UUID(), sessionName: "Sample Session", sessionDescription: "bla bla", createdAt: Date(), distanceCovered: 10.5, timeElapsed: 3600, averageSpeed: 5.0, checkPoints: [], wayPoints: [], locations: []))
//}
