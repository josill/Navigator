//
//  RequestLocationView.swift
//  gpsmapdemo23f
//
//  Created by Jonathan Sillak on 22.12.2023.
//

import SwiftUI

struct RequestLocationView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    
    var body: some View {
        Button(action: {
            locationVM.requestPermission()
        }, label: {
            Text("Allow tracking")
        })
    }
}

#Preview {
    RequestLocationView()
        .environmentObject(LocationViewModel())
}
