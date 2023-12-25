//
//  Routes.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import Foundation

public enum Routes: Equatable {
    case login, register
    case menu(User), viewSessions(User), createSession(User)
    case notificationsAllowed, locationAllowed
    case map(String)
    case none
    
    public static func == (lhs: Routes, rhs: Routes) -> Bool {
            switch (lhs, rhs) {
            case (.login, .login),
                 (.register, .register),
                 (.notificationsAllowed, .notificationsAllowed),
                 (.locationAllowed, .locationAllowed),
                 (.none, .none):
                return true
                
            case let (.menu(user1), .menu(user2)),
                 let (.viewSessions(user1), .viewSessions(user2)),
                 let (.createSession(user1), .createSession(user2)):
                return user1 == user2
                
            case let (.map(location1), .map(location2)):
                return location1 == location2
                
            default:
                return false
            }
        }
}
