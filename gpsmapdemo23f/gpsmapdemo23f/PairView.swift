//
//  PairView.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import SwiftUI

struct PairView: View {
    let leftText: String
    let rightText: String
    
    init(_ leftText: String, _ rightText: String) {
        self.leftText = leftText
        self.rightText = rightText
    }
    
    var body: some View {
        HStack {
            Text(leftText)
            Spacer()
            Text(rightText)
        }
    }
}

#Preview {
    PairView("Left", "Right")
}
