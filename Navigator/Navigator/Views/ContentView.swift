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
            LoginOrRegisterView()
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .login: LoginView()
                case .register: RegisterView()
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
