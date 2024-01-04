//
//  SessionLink.swift
//  Navigator
//
//  Created by Jonathan Sillak on 02.12.2023.
//

import SwiftUI
import UIKit
import MessageUI
import SwiftSMTP

struct SessionLink: View {
    @EnvironmentObject private var router: Router
    private let mail = MailSender.shared
    
    @State var session: Session
    @State private var email = ""
    @State private var showMailAlert = false
    
    @Binding var mailResult: Bool?
    @Binding var showMailResult: Bool
    
    var body: some View {
        HStack {
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
            .padding(.trailing, 20)
            
            Button {
                print("implement gpx download")
                showMailAlert.toggle()
            } label: {
                Image(systemName: "arrow.down.circle")
                    .font(.title)
            }
        }
        .padding(10)
        .background(.black)
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.blue)
        .alert("Enter your email", isPresented: $showMailAlert) {
            TextField("your email here", text: $email)
            
            HStack {
                Button("OK") {
                    mail.sendMail(
                        toEmail: email,
                        subject: "Your session - \(session.name) gpx data",
                        body: "TODO"
                    ) { res in
                        switch res {
                        case .success:
                            print("success")
                            mailResult = true
                        case .failure:
                            print("failure")
                            mailResult = false
                        }
                        showMailResult = true
                    }
                }
                Button("Cancel") {
                    showMailAlert.toggle()
                }
            }
        } message: {
            Text("We will email you the GPX file of the track!")
        }
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
