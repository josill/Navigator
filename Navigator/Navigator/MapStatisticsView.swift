//
//  MapInfoView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct MapStatisticsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    enum Mode {
        case main
        case checkPoint
        case wayPoint
        case compass
    }
    @State private var modeSelected = Mode.main
    @State private var distanceCovered = "100 m"
    @State private var sessionDuration = "00:30 h"
    @State private var averageSpeed = "4.8 km/h"
    
    @State private var distanceCoveredCp = "200 m"
    @State private var directLineCp = "01:30 h"
    @State private var averageSpeedCp = "5.2 km/h"
    
    @State private var distanceCoveredWp = "300 m"
    @State private var directLineWp = "02:30 h"
    @State private var averageSpeedWp = "5.6 km/h"
    
    var body: some View {
        ZStack {
           TabView(selection: $modeSelected) {
               ZStack {
                   Circle()
                       .scale(1)
                       .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                   
                   VStack(spacing: 8) {
                       Text("From start")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                       
                       Text("Distance covered: \(distanceCovered)")
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                       Text("Session duration: \(sessionDuration)")
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                       Text("Average speed: \(averageSpeed)")
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                   }
                   .background(colorScheme == .dark ? Color.black : Color.white)
               }
               .tag(Mode.main)
               .tabItem {
                   Label("Start", systemImage: "1.square.fill")

               }
               
               
               ZStack {
                   Circle().scale(1).foregroundColor(.white)
                   
                   VStack(spacing: 8) {
                       Text("From checkpoint")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                       
                       Text("Distance covered: \(distanceCoveredCp)")
                           .font(.subheadline)

                       Text("Direct line distance: \(directLineCp)")
                           .font(.subheadline)

                       Text("Average speed: \(averageSpeedCp)")
                           .font(.subheadline)
                   }
               }
               .tag(Mode.checkPoint)
               .tabItem {
                   Label("Checkpoint", systemImage: "2.square.fill")
               }
               
               ZStack {
                   Circle().scale(1).foregroundColor(.white)
                   
                   VStack(spacing: 8) {
                       Text("From waypoint")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                       
                       Text("Distance covered: \(distanceCoveredWp)")
                           .font(.subheadline)

                       Text("Direct line distance: \(directLineWp)")
                           .font(.subheadline)

                       Text("Average speed: \(averageSpeedWp)")
                           .font(.subheadline)
                   }
               }
               .tag(Mode.wayPoint)
               .tabItem {
                   Label("Waypoint", systemImage: "3.square.fill")
               }
               
               ZStack {
                   CompassView()
               }
               .tag(Mode.compass)
               .tabItem {
                   Label("Compass", systemImage: "location.north.circle")
                       .imageScale(.large)
               }
           }
           .frame(width: UIScreen.main.bounds.width, height: 200)
           .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
           .font(.system(size: 24))
       }
        .ignoresSafeArea()
    }
}

#Preview {
    MapStatisticsView()
}
