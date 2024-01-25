//
//  User.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation
import SwiftData
import CryptoKit

public struct User: Codable, Equatable {
    var email: String
    var salt: String
    var passwordHash: String
    var jwtToken: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case salt
        case passwordHash
        case jwtToken
    }
    
    init(
            email: String,
            password: String,
            jwtToken: String
        ) {
            self.email = email
            
            let salt = User.generateSalt()
            self.salt = salt
            self.passwordHash = User.hashPassword(password: password, salt: salt)
            self.jwtToken = jwtToken
        }
    
    private static func generateSalt() -> String {
        let randomData = Data.random(count: 16)
        return randomData.base64EncodedString()
    }
    
    private static func hashPassword(password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let passwordData = Data(saltedPassword.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return hashed.compactMap { String(format: "%02hhx", $0) }.joined()
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
            return lhs.email == rhs.email &&
                lhs.salt == rhs.salt &&
                lhs.passwordHash == rhs.passwordHash &&
                lhs.jwtToken == rhs.jwtToken
        }
}
