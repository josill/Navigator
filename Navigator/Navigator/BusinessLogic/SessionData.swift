//
//  SessionInfo.swift
//  Navigator
//
//  Created by Jonathan Sillak on 31.12.2023.
//

import Foundation

class SessionData: ObservableObject {
    static let shared = SessionData()
    private var sessionManager = SessionManager.shared
    
    @Published var sessionActive = false
    @Published var sessionQuitAlertPresented = false
    
    @Published var distanceCovered = 0.0
    @Published var distanceFromCp = 0.0
    @Published var distanceFromWp = 0.0
    @Published var directLineFromCp = 0.0
    @Published var directLineFromWp = 0.0
    
    var timer: Timer?
    @Published var sessionDurationSec = 0.0
    @Published var sessionDuration = "00:00:00"
    @Published var sessionDurationBeforeCp = 0.0
    @Published var sessionDurationBeforeWp = 0.0
    
    @Published var averageSpeed = 0.0
    @Published var averageSpeedFromCp = 0.0
    @Published var averageSpeedFromWp = 0.0
    
    enum updateType {
        case none, checkpoint, waypoint
    }
    
    func setSessionActive() {
        sessionActive.toggle()
        
        if sessionActive {
            sessionManager.startActivity()
        } else {
            sessionManager.stopActivity()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        distanceCovered = 0.0
        distanceFromCp = 0.0
        distanceFromWp = 0.0
        
        stopTimer()
        sessionDuration = "00:00:00"
        sessionDurationSec = 0.0
        
        directLineFromCp = 0.0
        directLineFromWp = 0.0
    }
    
    func updateDistance(for type: updateType, distance: Double) {
        if type == .none { distanceCovered += distance }
        else if type == .checkpoint { distanceFromCp += distance }
        else { distanceFromWp += distance }
    }
    
    func updateDirectLineDistance(for type: updateType, distance: Double) {
        if type == .none { return }
        else if type == .checkpoint { directLineFromCp = distance }
        else { directLineFromWp = distance }
    }
    
    func updateSpeed(for type: updateType, speed: Double) {
        if type == .none { averageSpeed = speed }
        else if type == .checkpoint { averageSpeedFromCp = speed }
        else { averageSpeedFromWp = speed }
    }
    
    func updateSessionDuration(time: Double) {
        sessionDurationSec = time
    }
    
    private func updateElapsedTime() {
        sessionDurationSec += 1.0
        
        let hours = Int(sessionDurationSec) / 3600
        let minutes = (Int(sessionDurationSec) % 3600) / 60
        let seconds = Int(sessionDurationSec) % 60
        
        sessionDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
