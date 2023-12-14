//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    var currentUser = DatabaseService.shared.currentUser

    var body: some View {
        if currentUser == nil {
            LoginOrRegisterView()
        } else {
            MenuView()
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
