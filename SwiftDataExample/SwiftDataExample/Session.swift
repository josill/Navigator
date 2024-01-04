//
//  Session.swift
//  SwiftDataExample
//
//  Created by Jonathan Sillak on 04.01.2024.
//

import Foundation
import SwiftData

@Model
class Session {
    @Attribute(.unique) var id: UUID
    var name: String
    var desc: String
    var recordedAt: Date
    var duration: Double
    var speed: Double
    var distance: Double

    init(id: UUID, name: String, description: String, recordedAt: Date, duration: Double, speed: Double, distance: Double) {
        self.id = id
        self.name = name
        self.desc = description
        self.recordedAt = recordedAt
        self.duration = duration
        self.speed = speed
        self.distance = distance
    }
}
