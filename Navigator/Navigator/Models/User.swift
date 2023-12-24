//
//  User.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation
import SwiftData
import CryptoKit

class User: Codable {
//    var userId: UUID
//    var firstName: String?
//    var lastName: String?
//    @Attribute(.unique) var email: String
    var email: String
    var salt: String
    var passwordHash: String
    var jwtToken: String?
//    @Relationship(deleteRule: .cascade, inverse: \Session.user)
//    var sessions = [Session]()
    
    enum CodingKeys: String, CodingKey {
//        case userId
//        case firstName
//        case lastName
        case email
        case salt
        case passwordHash
        case jwtToken
//        case sessions
    }
    
    init(
//            userId: UUID = UUID(),
//            firstName: String? = nil,
//            lastName: String? = nil,
            email: String,
            password: String,
            jwtToken: String
        ) {
//            self.userId = userId
//            self.firstName = firstName
//            self.lastName = lastName
            self.email = email
            
            let salt = User.generateSalt()
            self.salt = salt
            self.passwordHash = User.hashPassword(password: password, salt: salt)
//            self.sessions = []
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        userId = try container.decode(UUID.self, forKey: .userId)
//        firstName = try container.decode(String.self, forKey: .firstName)
//        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        salt = try container.decode(String.self, forKey: .salt)
        passwordHash = try container.decode(String.self, forKey: .passwordHash)
        jwtToken = try container.decode(String?.self, forKey: .jwtToken)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(userId, forKey: .userId)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(salt, forKey: .salt)
        try container.encode(passwordHash, forKey: .passwordHash)
        try container.encode(jwtToken, forKey: .jwtToken)
    }
}
