//
//  MapOptionsView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct MapOptionsView: View {
    @ObservedObject var locationManager = LocationManager.shared

    var body: some View {
        HStack {
            Spacer()
            
            Button {
                print("start tracking")
                locationManager.trackingEnabled = !locationManager.trackingEnabled
            } label: {
                Image(systemName: "play")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.addCheckpoint()
            } label: {
                Image(systemName: "mappin.and.ellipse")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.addWaypoint()
            } label: {
                Image(systemName: "pin")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                locationManager.reset()
            } label: {
                Image(systemName: "gobackward")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
        }
    }
}

#Preview {
    MapOptionsView()
}
