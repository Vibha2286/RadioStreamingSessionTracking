//
//  RadioStreamingSessionPresenter.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

final class RadioStreamingSessionPresenter: ObservableObject {
    
    @Published var sessions: [RadioSession] = []

    private let interactor: RadioStreamingSessionInteractor
    private let router: RadioStreamingSessionRouter

    init(interactor: RadioStreamingSessionInteractor,
         router: RadioStreamingSessionRouter) {
        self.interactor = interactor
        self.router = router
        fetchSessions()
    }

    // Fetch all sessions from the interactor
    func fetchSessions() {
        sessions = interactor.getSessions()
    }

    // Add a new session
    func addSession(id: String, startTime: Date, endTime: Date) {
        interactor.addSession(id: id, startTime: startTime, endTime: endTime)
        fetchSessions()
    }

    // Remove a session by ID
    func removeSession(id: String) {
        interactor.removeSession(id: id)
        fetchSessions()
    }

    // Get total effective streaming time
    func getTotalEffectiveTime() -> TimeInterval {
        return interactor.calculateEffectiveStreamingDuration(sessions: sessions)
    }
    
    // Function to check if a session overlaps with any of the overlapping ranges
    func fetchOverlappedSession(sessions: [RadioSession]) -> [ClosedRange<Date>] {
        return interactor.calculateOverlappingRanges(sessions: sessions)
    }
    
    // Effective duration after reducing overlapped time
    func fetchEffectiveDucration(_ sessions: [RadioSession]) -> [RadioSession] {
        return interactor.mergeOverlappingSessions(sessions)
    }
    
    // Calculate total session duration
    func totalSessionDuration(session: [RadioSession]) -> String {
        let totalDuration = session.reduce(0) { total, session in
            total + session.endTime.timeIntervalSince(session.startTime)
        }
        let hours = Int(totalDuration / 3600)
        let minutes = Int((totalDuration.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
}
