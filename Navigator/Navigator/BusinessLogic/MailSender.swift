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
    
    func sendMail(toEmail to: String, subject: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let toEmail = Mail.User(email: to)
        
        let mail = Mail(
            from: fromEmail,
            to: [toEmail],
            subject: subject,
            text: body
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
}
