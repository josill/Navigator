//
//  Session.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation

struct Session {
    var sessionId : UUID
    var userId: UUID
    var sessionName: String
    var createdAt: Date
    var distanceCovered: Double
    var timeElapsed: Double
    var averageSpeed: Double
    var checkPoints: [UserLocation]
    var wayPoints: [UserLocation]
    var locations: [UserLocation]
}
