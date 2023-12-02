//
//  LoginView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 13.11.2023.
//

import SwiftUI

struct SessionsView: View {
    @ObservedObject var authHelper = AuthenticationHelper()
    
    let sessions: [Session] = [
        Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 1", createdAt: Date(), distanceCovered: 10.5, timeElapsed: 3600, averageSpeed: 5.0, checkPoints: [], wayPoints: [], locations: []),
        Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 2", createdAt: Date(), distanceCovered: 15.7, timeElapsed: 4500, averageSpeed: 7.0, checkPoints: [], wayPoints: [], locations: []),
        Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 3", createdAt: Date(), distanceCovered: 8.2, timeElapsed: 3000, averageSpeed: 4.0, checkPoints: [], wayPoints: [], locations: []),
        Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 4", createdAt: Date(), distanceCovered: 20.1, timeElapsed: 6000, averageSpeed: 6.7, checkPoints: [], wayPoints: [], locations: []),
        Session(sessionId: UUID(), userId: UUID(), sessionName: "Session 5", createdAt: Date(), distanceCovered: 12.3, timeElapsed: 4200, averageSpeed: 5.8, checkPoints: [], wayPoints: [], locations: []),
        // Add more sessions as needed
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Sessions:")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                List(sessions, id: \.sessionId) { session in
                    NavigationLink(destination: MapView()) {
                        EmptyView()
                    }
                    .background(.black)
                    .listRowBackground(Color.black)
                    .listRowSeparator(.hidden)
                    .hidden()

                    HStack {
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
                        
                        Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .font(.title)
                    }
                    .background(.black)
                    .listRowBackground(Color.black)
                    .listRowSeparatorTint(.blue)
                    .offset(y: -25)
                }
               .background(.black)
               .scrollContentBackground(.hidden)
            }
            .background(.black)
        }
    }
    
    func formatDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy 'at' h:mm a"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SessionsView()
}
