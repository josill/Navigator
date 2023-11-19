//
//  CompassView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var compassManager = CompassManager.shared
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker, compassDegrees: 0)
                }
            }
            .rotationEffect(Angle(degrees: self.compassManager.degrees))
            .statusBarHidden()
        }
    }
}

#Preview {
    CompassView()
}
