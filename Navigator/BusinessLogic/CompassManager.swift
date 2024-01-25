//
//  CompassManager.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import Foundation
import Combine
import CoreLocation

class CompassManager: NSObject, ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    static let shared = CompassManager()
}
