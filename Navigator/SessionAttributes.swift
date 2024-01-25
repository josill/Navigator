//
//  SessionAttributes.swift
//  Navigator
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import Foundation
import ActivityKit


public struct SessionAttributes: ActivityAttributes {
//    public typealias SessionInfo = ContentState
    
    public struct ContentState: Codable & Hashable {
        let sessionDistance: Double
        let sessionDuration: String
        let sessionSpeed: Double
    }
}
