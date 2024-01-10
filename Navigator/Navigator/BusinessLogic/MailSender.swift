//
//  MailSender.swift
//  Navigator
//
//  Created by Jonathan Sillak on 04.01.2024.
//

import Foundation
import SwiftSMTP

struct MailSender {
    static let shared = MailSender()
        
    private let smtp: SMTP
    private let fromEmail: Mail.User
    
    init() {
        guard let hostname = ProcessInfo.processInfo.environment["SMTP_HOSTNAME"],
              let email = ProcessInfo.processInfo.environment["SMTP_EMAIL"],
              let password = ProcessInfo.processInfo.environment["SMTP_PASSWORD"] else {
            fatalError("SMTP configuration missing in environment variables.")
        }
        
        self.smtp = SMTP(
            hostname: hostname,
            email: email,
            password: password
        )
        
        fromEmail = Mail.User(email: email)
    }
    
    func sendMail(
        toEmail to: String,
        subject: String,
        body: String,
        session: Session,
        completion: @escaping (Result<Void, Error>) -> Void) {
        let toEmail = Mail.User(email: to)
        
        let data = self.createGpxFile(session).data(using: .utf8)!
        let gpxAttachment = Attachment(
            data: data,
            mime: "application/gpx+xml",
            name: "track-\(self.formatDate(Date())).gpx",
            inline: false
        )
        
        let mail = Mail(
            from: fromEmail,
            to: [toEmail],
            subject: subject,
            text: body,
            attachments: [gpxAttachment]
        )
        
        Task { @MainActor in
            smtp.send(mail) { error in
                if let error = error {
                    completion(.failure(error))
                }
            }
            completion(.success(()))
        }
    }
    
    private func createGpxFile(_ session: Session) -> String {
        var checkpointNr = 1
        var wayPointNr = 1
        
        var gpxContent = """
        <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
        <gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.0" creator="Navigator">
        """
        
        for location in session.locations.sorted(by: { $0.createdAt < $1.createdAt }) {
            if location.locationType != .location {
                gpxContent += """
                \n  <wpt lat="\(location.latitude)" lon="\(location.longitude)">
                    <name>\(location.locationType == .checkPoint ? "Checkpoint \(checkpointNr)" : "Waypoint \(wayPointNr)")</name>
                  </wpt>
                """
                
                if (location.locationType == .checkPoint) { checkpointNr += 1 }
                else { wayPointNr += 1 }
            }
        }
    
        gpxContent += """
        \n  <trk>
            <name>\(session.name)</name>
            <trkseg>
        """
                
        for (i, location) in session.locations.sorted(by: { $0.createdAt < $1.createdAt }).enumerated() {
            gpxContent += """
            \n    <trkpt lat="\(location.latitude)" lon="\(location.longitude)">
                  <name>TP\(i+1)</name>
                  <time>\(formatDate(location.createdAt))</time>
                </trkpt>
            """
        }
        
        gpxContent += """
        \n    </trkseg>
          </trk>
        """
        
        gpxContent += """
        \n</gpx>
        """
        
        return gpxContent
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: date)
    }
}
