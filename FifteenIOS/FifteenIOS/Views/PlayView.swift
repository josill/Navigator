//
//  PlayView.swift
//  FifteenIOS
//
//  Created by Jonathan Sillak on 18.12.2023.
//

import SwiftUI

struct PlayView: View {
    var body: some View {
        VStack(spacing: 0) {
            GameControls()
                .frame(height: UIScreen.main.bounds.height / 3)
            
            GameBoard()
                .frame(height: (UIScreen.main.bounds.height / 3) * 2)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PlayView()
}
