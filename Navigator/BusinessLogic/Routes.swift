//
//  Routes.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import Foundation

enum Routes: Equatable {
    case login, register
    case menu, viewSessions, createSession
    case notificationsAllowed, locationAllowed
    case mapActive, mapNonActive(Session)
    case none
    
    public static func == (lhs: Routes, rhs: Routes) -> Bool {
            switch (lhs, rhs) {
            case (.login, .login),
                 (.register, .register),
                 (.menu, .menu),
                 (.viewSessions, .viewSessions),
                 (.createSession, .createSession),
                 (.notificationsAllowed, .notificationsAllowed),
                 (.locationAllowed, .locationAllowed),
                 (.mapActive, .mapActive),
                 (.mapNonActive, .mapNonActive),
                 (.none, .none):
                return true
                
            default:
                return false
            }
        }
}
