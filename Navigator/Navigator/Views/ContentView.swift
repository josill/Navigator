//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authHelper: AuthenticationHelper
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginOrRegisterView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        print("main view: \(authHelper.savedUser)")

                        if authHelper.savedUser != nil {
                            router.changeRoute(.init(.menu))
                        }
                    }
                }
                .navigationDestination(for: RoutePath.self) { route in
                    switch route.route {
                    case .login: LoginView()
                    case .register: RegisterView()
                    case .menu: MenuView()
                    case .createSession: CreateSessionView()
                    case .viewSessions: SessionsView()
                    case .locationAllowed: LocationRequestView()
                    case .notificationsAllowed: NotificationRequestView()
                    case .map: MapView()
                    case .none: LoginOrRegisterView()
                    }
                }
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
