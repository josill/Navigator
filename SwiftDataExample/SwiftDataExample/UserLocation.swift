//
//  UserLocation.swift
//  SwiftDataExample
//
//  Created by Jonathan Sillak on 04.01.2024.
//

import Foundation
import CoreLocation
import SwiftData

@Model
class UserLocation {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var locationType: LocationType
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var accuracy: CLLocationAccuracy?
//    var verticalAccuracy: CLLocationAccuracy?
    var altitude: Double?
    @Relationship(deleteRule: .cascade) var session: Session?
    
    enum LocationType: String, Codable { case location, checkPoint, wayPoint }

    init(
        locationType: LocationType? = .location,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        accuracy: CLLocationAccuracy? = 0,
//        verticalAccuracy: CLLocationAccuracy? = 0,
        altitude: Double? = 0,
        session: Session?
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.locationType = locationType ?? .location
        self.latitude = latitude
        self.longitude = longitude
        if let accuracy = accuracy { self.accuracy = accuracy }
//        if let verticalAccuracy = verticalAccuracy { self.verticalAccuracy = verticalAccuracy }
        if let altitude = altitude { self.altitude = altitude }
        self.session = session
    }
}
