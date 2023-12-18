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
                .frame(height: UIScreen.main.bounds.height / 4)
            
            GameBoard()
                .frame(height: (UIScreen.main.bounds.height / 4) * 3)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PlayView()
}
