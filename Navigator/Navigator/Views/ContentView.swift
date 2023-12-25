//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authHelper = AuthenticationHelper()
    @StateObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LoginOrRegisterView()
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
