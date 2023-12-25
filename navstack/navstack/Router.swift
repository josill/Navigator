//
//  Router.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import Foundation

public struct RoutePath: Hashable {
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
    static let shared: Router = Router()
    
    public var changeRoute: ((RoutePath) -> Void)!
    public var backRoute: (() -> Void)!
    public var backtoRootRoute: (() -> Void)!
}
