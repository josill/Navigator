//
//  NavigationRouteView.swift
//  navstack
//
//  Created by Jonathan Sillak on 25.12.2023.
//

import SwiftUI

struct NavigationRouteView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 10) {
                Text("Root view")
                Button {
                    Router.shared.changeRoute(RoutePath(.menu))
                } label: {
                    Text("Go to user create")
                }
                Button {
                    let user = User("George")
                    Router.shared.changeRoute(RoutePath(.map))
                } label: {
                    Text("Go to user edit")
                }
                
                Button {
                    Router.shared.changeRoute(RoutePath(.login))
                } label: {
                    Text("go to main screen")
                }
            }
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .login:
                    LoginOrRegisterView()
                case .register:
                    Text("User create view comes here")
                case .menu:
                    Text("User create view comes here")
                case .createSession:
                    Text("User create view comes here")
                case .viewSessions:
                    Text("User create view comes here")
                case .locationAllowed:
                    Text("User create view comes here")
                case .notificationsAllowed:
                    Text("User create view comes here")
                case .map:
                    Text("User create view comes here")
                case .none:
                    Text("User create view comes here")
                }
            }
        }
    }

    // MARK: Route
    func changeRoute(_ route: RoutePath) {
        print("route is: \(route.route)")
        path.append(route)
        print("path is: \(path)")
    }
    

    func backRoute() {
        path.removeLast()
    }
}

#Preview {
    NavigationRouteView()
}
