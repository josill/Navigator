//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authHelper = AuthenticationHelper.shared
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginOrRegisterView()
                .onAppear {
                    Task {
                        if authHelper.savedUser != nil {
                            router.changeRoute(.init(.map))
                        }
                    }
                }
                .navigationDestination(for: RoutePath.self) { route in
                    switch route.route {
                    case .login: LoginView()
                    case .register: RegisterView()
                    case .menu: MenuView().navigationBarBackButtonHidden()
                    case .createSession: CreateSessionView()
                    case .viewSessions: SessionsView()
                    case .locationAllowed: LocationRequestView()
                    case .notificationsAllowed: NotificationRequestView().navigationBarBackButtonHidden()
                    case .map: MapView().navigationBarBackButtonHidden()
                    case .none: LoginOrRegisterView()
                    }
                }
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
