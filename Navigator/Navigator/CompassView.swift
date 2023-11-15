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
            Capsule()
                .frame(width: 5, height: 50)
            
            ZStack {
                ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker, compassDegrees: 0)
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle(degrees: self.compassManager.degrees))
            .statusBarHidden()
        }
    }
}

#Preview {
    CompassView()
}
