//
//  User.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation

struct User {
    var userId: UUID
    var username: String
    var passwordHash: String
    var salt: String
}
