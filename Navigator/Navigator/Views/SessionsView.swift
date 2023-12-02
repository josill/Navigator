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
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Sessions:")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                List(sessions, id: \.sessionId) { session in
                    SessionLink(session: session)
                }
               .background(.black)
               .scrollContentBackground(.hidden)
            }
            .background(.black)
        }
    }
}

#Preview {
    SessionsView()
}
