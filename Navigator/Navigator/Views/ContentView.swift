//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 10) {
                Text("Root view")
                Button {
                    router.changeRoute(RoutePath(.menu))
                } label: {
                    Text("Go to user create")
                }
                Button {
                    router.changeRoute(RoutePath(.map))
                } label: {
                    Text("Go to user edit")
                }
                
                Button {
                    router.changeRoute(RoutePath(.login))
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
}

#Preview {
    LoginOrRegisterView()
}
