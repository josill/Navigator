//
//  Config.swift
//  Navigator
//
//  Created by Jonathan Sillak on 10.01.2024.
//

import Foundation

struct Config {
    static let shared = Config()
    
    let backendUrl = "https://sportmap.akaver.com"
    let smtpHostname = "the host where your email is located on, f.e smtp.gmail.com"
    let smtpEmail = "email where we send the gpx data from"
    let smtpPassword = "for your email"
    
    print("Test .gitignore")
}
