//
//  SessionControlsWidget.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import SwiftUI
import ActivityKit

struct SessionControlsWidget: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button(intent: StartOrStopIntent()) {
                Image(systemName: "play")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 18))
            
            Spacer()
            
            Button(intent: AddCheckpointIntent()) {
                Image(systemName: "mappin.and.ellipse")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 18))
            
            Spacer()
            
            Button(intent: AddWaypointIntent()) {
                Image(systemName: "pin")
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 18))
            
            Spacer()
            
            Button(intent: QuitSessionIntent()) {
                Image(systemName: "power")
                    .foregroundColor(.clear)
                    .background(.clear)
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 18))
            
            Spacer()
        }
    }
    
    func startActivity() {
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
}

#Preview {    
    SessionControlsWidget()
        .environmentObject(LocationManager())
        .environmentObject(NotificationManager())
}
