//
//  PlayView.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.verticalSizeClass) var orientation
    
    @StateObject private var gameBrain = GameBrain()

    var body: some View {
        if orientation == .compact {
            HStack {
                GameControls(gameBrain: gameBrain)
                    .frame(height: UIScreen.main.bounds.height / 3)
                
                GameBoard(gameBrain: gameBrain)
                    .frame(height: (UIScreen.main.bounds.height / 3) * 2)
            }
        } else {
            VStack(spacing: 0) {
                GameControls(gameBrain: gameBrain)
                    .frame(height: UIScreen.main.bounds.height / 3)
                
                GameBoard(gameBrain: gameBrain)
                    .frame(height: (UIScreen.main.bounds.height / 3) * 2)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PlayView()
}
