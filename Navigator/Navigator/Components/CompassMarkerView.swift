//
//  CompassMarkerView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegrees: Double
    
    var body: some View {
        VStack {
            Text("\(marker.degreeText())")
                .fontWeight(.light)
                .rotationEffect(self.textAngle())
            
            Capsule()
                .frame(
                    width: self.capsuleWidth(),
                    height: self.capsuleHeight())
                .foregroundColor(self.capsuleColor())
                .padding(.bottom, 80)
            
            Text(marker.label)
                .fontWeight(.bold)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 80)
        }
        .rotationEffect(Angle(degrees: marker.degrees))
    }
    
    private func capsuleWidth() -> CGFloat { self.marker.degrees == 0 ? 5: 2 }
    private func capsuleHeight() -> CGFloat { self.marker.degrees == 0 ? 32 : 16 }
    private func capsuleColor() -> Color { self.marker.degrees == 0 ? .red : .gray }
    private func textAngle() -> Angle { Angle(degrees: -self.compassDegrees - self.marker.degrees) }
    
}

#Preview {
    CompassMarkerView(marker: Marker(degrees: 0), compassDegrees: 0)
}
