//
//  Location.swift
//  Navigator
//
//  Created by Jonathan Sillak on 14.11.2023.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
