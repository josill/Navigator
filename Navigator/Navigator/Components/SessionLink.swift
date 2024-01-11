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
        Button {
            print("Session id is \(session.id)")
            router.changeRoute(.init(.mapNonActive(session)))
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(session.name)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("Created at: \(formatDateString(session.recordedAt))")
                        .foregroundColor(.white)
                    Text("Distance covered: \(formatDistance(session.distance)) meters")
                        .foregroundColor(.white)
                    Text("Time elapsed: \(session.duration)")
                        .foregroundColor(.white)
                    Text("Average speed: \(String(format: "%.2f", session.speed))")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 20)
                
                Button {
                    showMailAlert.toggle()
                } label: {
                    Image(systemName: "arrow.down.circle")
                        .font(.title)
                }
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
                    Task { @MainActor in
                        mail.sendMail(
                            toEmail: email,
                            subject: "Your session - \(session.name) gpx data",
                            body: """
                            Hello from Navigator!
                            
                            We have attached your GPX file as an attachment to the end of this letter.
                            
                            Until the next journey,
                            Navigator team
                            """,
                            session: session
                        ) { res in
                            switch res {
                            case .success:
                                mailResult = true
                            case .failure:
                                mailResult = false
                            }
                            showMailResult = true
                        }
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
    
    func formatDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
