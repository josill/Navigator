//
//  User.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation
import CryptoKit

struct User {
    var userId: UUID
    var firstName: String
    var lastName: String
    var email: String
    var salt: String
    var passwordHash: String
    var jwtToken: String?
    
    init(
        userId: UUID = UUID(),
        firstName: String,
        lastName: String,
        email: String,
        salt: String,
        passwordHash: String,
        jwtToken: String? = nil
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.salt = salt
        self.passwordHash = passwordHash
                
        if let jwtToken = jwtToken {
            self.jwtToken = jwtToken
        }
    }
}
