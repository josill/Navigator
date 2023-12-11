//
//  UserLocation.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.11.2023.
//

import Foundation
import CoreLocation
import SwiftData

@Model
class UserLocation: Codable {
    var createdAt: Date
    var locationId: UUID
    var locationTypeId: UUID
    var sessionId: UUID
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var accuracy: CLLocationAccuracy
    var verticalAccuracy: CLLocationAccuracy
    var altitude: Double
    var session: Session?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case locationId
        case locationTypeId
        case sessionId
        case latitude
        case longitude
        case accuracy
        case verticalAccuracy
        case altitude
        case session
    }
    
    init(
        locationId: UUID,
        locationTypeId: UUID,
        sessionId: UUID,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        accuracy: CLLocationAccuracy,
        verticalAccuracy: CLLocationAccuracy,
        altitude: Double,
        session: Session?
    ) {
        self.createdAt = Date()
        self.locationId = locationId
        self.locationTypeId = locationTypeId
        self.sessionId = sessionId
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
        self.verticalAccuracy = verticalAccuracy
        self.altitude = altitude
        self.session = session
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        locationId = try container.decode(UUID.self, forKey: .locationId)
        locationTypeId = try container.decode(UUID.self, forKey: .locationTypeId)
        sessionId = try container.decode(UUID.self, forKey: .sessionId)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        accuracy = try container.decode(CLLocationAccuracy.self, forKey: .accuracy)
        verticalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
        altitude = try container.decode(Double.self, forKey: .altitude)
        session = try container.decodeIfPresent(Session.self, forKey: .session)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(locationTypeId, forKey: .locationTypeId)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(accuracy, forKey: .accuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(altitude, forKey: .altitude)
        try container.encodeIfPresent(session, forKey: .session)
    }
}
