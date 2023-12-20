//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    var currentUser = DatabaseService.shared.currentUserStored
    
    var body: some View {
        if currentUser == nil {
//            MapView()
             LoginOrRegisterView()
        } else {
            MenuView()
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
