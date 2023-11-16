//
//  MapInfoView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct MapStatisticsView: View {
    enum Mode {
        case main
        case checkPoint
        case wayPoint
    }
    @State private var modeSelected = Mode.main
    
    var body: some View {
        ZStack {
           TabView(selection: $modeSelected) {
               Text("Main")
                   .tag(Mode.main)
                   .tabItem {
                       Label("Main", systemImage: "1.square.fill")
                   }
               
               Text("Checkpoint")
                   .tag(Mode.checkPoint)
                   .tabItem {
                       Label("Checkpoint", systemImage: "2.square.fill")
                   }
               
               Text("Waypoint")
                   .tag(Mode.wayPoint)
                   .tabItem {
                       Label("Waypoint", systemImage: "3.square.fill")
                   }
           }
           .frame(
               width: UIScreen.main.bounds.width ,
               height: 200
           )
           .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
           .padding()
           .font(.system(size: 24))
       }
        .ignoresSafeArea()
    }
}

#Preview {
    MapStatisticsView()
}
