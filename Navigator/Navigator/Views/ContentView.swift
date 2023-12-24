//
//  ContentView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 03.11.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authHelper = AuthenticationHelper()
    
    var body: some View {
        if authHelper.savedUser == nil {
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
