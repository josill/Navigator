//
//  Handle.swift
//  Navigator
//
//  Created by Jonathan Sillak on 17.11.2023.
//

import SwiftUI

struct Handle: View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

#Preview {
    Handle()
}
