//
//  Router.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import Foundation
import SwiftUI

struct RoutePath: Hashable {
    public var route: Routes = .none
    var hashValue = { UUID().uuid }
    public init(_ route: Routes) {
        self.route = route
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
    
    public static func == (lhs: RoutePath, rhs: RoutePath) -> Bool {
        lhs.route == rhs.route
    }
}

class Router: ObservableObject {
    @Published var path: [RoutePath] = []
    static let shared: Router = Router()
    
    func reset() {
        path = []
    }
    
    func changeRoute(_ route: RoutePath) {
        path.append(route)
    }

    func backRoute() {
        path.removeLast()
    }
    
    func backToMenuRoute() {
        if let mapRoutePathIndex = path.firstIndex(where: { $0.route == .menu }) {
            let elementsToRemove = path.count - (mapRoutePathIndex + 1)
            path.removeLast(elementsToRemove)
        }
    }
    
    func lastRoute() -> RoutePath? {
        return path.last
    }
}

