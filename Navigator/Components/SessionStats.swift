//
//  MapInfoView.swift
//  Navigator
//
//  Created by Jonathan Sillak on 16.11.2023.
//

import SwiftUI

struct SessionStats: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var sessionData = SessionData.shared
    
    enum Mode {
        case main
        case checkPoint
        case wayPoint
        case compass
    }
    @State private var modeSelected = Mode.main
    
    var body: some View {
        ZStack {
           TabView(selection: $modeSelected) {
               ZStack {
                   VStack(spacing: 8) {
                       Text("From start")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                       
                       Text("Distance covered: \(String(format: "%.2f", sessionData.distanceCovered)) m")
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                       Text("Session duration: \(sessionData.sessionDuration)")
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                       Text("Average speed: \(String(format: "%.2f", sessionData.averageSpeed)) km/h")
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
                   VStack(spacing: 8) {
                       Text("From checkpoint")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                       
                       Text("Distance covered: \(String(format: "%.2f", sessionData.distanceFromCp )) m")
                           .font(.subheadline)

                       Text("Direct line distance: \(String(format: "%.2f", sessionData.directLineFromCp )) m")
                           .font(.subheadline)

                       Text("Average speed: \(String(format: "%.2f", sessionData.averageSpeedFromCp)) km/h")
                           .font(.subheadline)
                   }
               }
               .tag(Mode.checkPoint)
               .tabItem {
                   Label("Checkpoint", systemImage: "2.square.fill")
               }
               
               ZStack {                   
                   VStack(spacing: 8) {
                       Text("From waypoint")
                           .font(.title)
                           .fontWeight(.bold)
                           .padding(.bottom, 8)
                       
                       Text("Distance covered: \(String(format: "%.2f", sessionData.distanceFromWp ))")
                           .font(.subheadline)

                       Text("Direct line distance: \(String(format: "%.2f", sessionData.directLineFromWp ))")
                           .font(.subheadline)

                       Text("Average speed: \(String(format: "%.2f", sessionData.averageSpeedFromWp)) km/h")
                           .font(.subheadline)
                   }
               }
               .tag(Mode.wayPoint)
               .tabItem {
                   Label("Waypoint", systemImage: "3.square.fill")
               }
               
               if verticalSizeClass != .compact {
                   ZStack {
                       Compass()
                   }
                   .tag(Mode.compass)
                   .tabItem {
                       Label("Compass", systemImage: "location.north.circle")
                           .imageScale(.large)
                   }
               }
           }
           .frame(width: UIScreen.main.bounds.width, height: getHeightForCurrentTab())
           .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
           .font(.system(size: 24))
       }
        .ignoresSafeArea()
    }
    
    private func getHeightForCurrentTab() -> CGFloat {
        if modeSelected == .compass { return 600 }
        else { return 200 }
    }
}

#Preview {
    SessionStats()
}
