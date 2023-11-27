//
//  User.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation

struct User {
    var userId: UUID
    var firstName: String
    var lastName: String
    var email: String
    var passwordHash: String
    var salt: String
}
