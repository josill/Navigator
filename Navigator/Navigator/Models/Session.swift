// Session.swift
// Navigator
//
// Created by Jonathan Sillak on 25.11.2023.

import Foundation

struct Session: Codable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var recordedAt: Date
    var duration: Double
    var speed: Double
    var distance: Double
    var climb: Double
    var descent: Double
    var paceMin: Double
    var paceMax: Double
    var gpsSessionType: String
    var gpsLocationsCount: Double
    var userFirstLastName: String
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case recordedAt
        case duration
        case speed
        case distance
        case climb
        case descent
        case paceMin
        case paceMax
        case gpsSessionType
        case gpsLocationsCount
        case userFirstLastName
        case userId
    }
    
    init(
        id: UUID,
        name: String,
        description: String,
        recordedAt: Date = Date(),
        duration: Double = 0,
        speed: Double = 0,
        distance: Double = 0,
        climb: Double = 0,
        descent: Double = 0,
        paceMin: Double = 0,
        paceMax: Double = 0,
        gpsSessionType: String = "",
        gpsLocationsCount: Double = 0,
        userFirstLastName: String = "",
        userId: UUID
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.recordedAt = recordedAt
        self.duration = duration
        self.speed = speed
        self.distance = distance
        self.climb = climb
        self.descent = descent
        self.paceMin = paceMin
        self.paceMax = paceMax
        self.gpsSessionType = gpsSessionType
        self.gpsLocationsCount = gpsLocationsCount
        self.userFirstLastName = userFirstLastName
        self.userId = userId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        duration = try container.decode(Double.self, forKey: .duration)
        speed = try container.decode(Double.self, forKey: .speed)
        distance = try container.decode(Double.self, forKey: .distance)
        climb = try container.decode(Double.self, forKey: .climb)
        descent = try container.decode(Double.self, forKey: .descent)
        paceMin = try container.decode(Double.self, forKey: .paceMin)
        paceMax = try container.decode(Double.self, forKey: .paceMax)
        gpsSessionType = try container.decode(String.self, forKey: .gpsSessionType)
        gpsLocationsCount = try container.decode(Double.self, forKey: .gpsLocationsCount)
        userFirstLastName = try container.decode(String.self, forKey: .userFirstLastName)
        userId = try container.decode(UUID.self, forKey: .userId)

        let iso8601Decoder = ISO8601DateFormatter()
        iso8601Decoder.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let recordedAtString = try? container.decode(String.self, forKey: .recordedAt),
           let date = iso8601Decoder.date(from: recordedAtString) {
            recordedAt = date
        } else {
            recordedAt = Date()
        }
    }

}
