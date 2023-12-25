//
//  Router.swift
//  Navigator
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    static let shared: Router = Router()
    
    func returnToRoot() {
        print("returnToRoot()")
        print(path.count)
        path.removeLast(path.count)
    }
}
