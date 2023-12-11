//
//  Session.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation
import SwiftData

@Model
class Session: Codable {
    var sessionId : UUID
    var sessionName: String
    var createdAt: Date
    var distanceCovered: Double
    var timeElapsed: Double
    var averageSpeed: Double
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var checkPoints = [UserLocation]()
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var wayPoints = [UserLocation]()
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var locations = [UserLocation]()
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionName
        case createdAt
        case distanceCovered
        case timeElapsed
        case averageSpeed
        case checkPoints
        case wayPoints
        case locations
        case user
    }
    
    init(
        sessionId: UUID, 
        sessionName: String,
        createdAt: Date,
        distanceCovered: Double,
        timeElapsed: Double,
        averageSpeed: Double,
        checkPoints: [UserLocation],
        wayPoints: [UserLocation],
        locations: [UserLocation]
    ) {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.createdAt = createdAt
        self.distanceCovered = distanceCovered
        self.timeElapsed = timeElapsed
        self.averageSpeed = averageSpeed
        self.checkPoints = checkPoints
        self.wayPoints = wayPoints
        self.locations = locations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionId = try container.decode(UUID.self, forKey: .sessionId)
        sessionName = try container.decode(String.self, forKey: .sessionName)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        distanceCovered = try container.decode(Double.self, forKey: .distanceCovered)
        timeElapsed = try container.decode(Double.self, forKey: .timeElapsed)
        averageSpeed = try container.decode(Double.self, forKey: .averageSpeed)
        checkPoints = try container.decode([UserLocation].self, forKey: .checkPoints)
        wayPoints = try container.decode([UserLocation].self, forKey: .wayPoints)
        locations = try container.decode([UserLocation].self, forKey: .locations)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(sessionName, forKey: .sessionName)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(distanceCovered, forKey: .distanceCovered)
        try container.encode(averageSpeed, forKey: .averageSpeed)
        try container.encode(checkPoints, forKey: .checkPoints)
        try container.encode(wayPoints, forKey: .wayPoints)
        try container.encode(locations, forKey: .locations)
    }
}
