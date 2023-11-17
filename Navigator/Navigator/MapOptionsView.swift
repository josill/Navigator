//
//  MapOptionsView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct MapOptionsView: View {
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                print("North-up")
            } label: {
                Image(systemName: "arrowshape.up")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                print("Reset")
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
            
            Button {
                print("Options")
            } label: {
                Image(systemName: "gearshape")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    MapOptionsView()
}
