//
//  RadioStreamingSessionInteractor.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import Foundation

final class RadioStreamingSessionInteractor {
    
    var sessions: [RadioSession] = []

    // Function to get all sessions
    func getSessions() -> [RadioSession] {
        return sessions
    }

    // Function to add a session
    func addSession(id: String, startTime: Date, endTime: Date) {
        let newSession = RadioSession(id: id, startTime: startTime, endTime: endTime)
        sessions.append(newSession)
    }

    // Function to remove a session by ID
    func removeSession(id: String) {
        sessions.removeAll { $0.id == id }
    }

    // Algorithm to calculate the total effective streaming time
    func calculateEffectiveStreamingDuration(sessions: [RadioSession]) -> TimeInterval {
        // Step 1: Sort sessions by start time
        let sortedSessions = sessions.sorted { $0.startTime < $1.startTime }

        // Step 2: Merge overlapping sessions
        var mergedSessions: [RadioSession] = []
        
        for session in sortedSessions {
            if let last = mergedSessions.last {
                // If the current session overlaps with the last merged session
                if session.startTime <= last.endTime {
                    // Merge the sessions by extending the last session's end time
                    let newSession = RadioSession(id: session.id, startTime: last.startTime, endTime: max(last.endTime, session.endTime))
                    mergedSessions[mergedSessions.count - 1] = newSession
                } else {
                    // No overlap, add the current session to the merged list
                    mergedSessions.append(session)
                }
            } else {
                // Add the first session to the merged list
                mergedSessions.append(session)
            }
        }
        
        // Step 3: Calculate the total effective streaming duration
        var totalDuration: TimeInterval = 0
        for session in mergedSessions {
            totalDuration += session.endTime.timeIntervalSince(session.startTime)
        }
        
        return totalDuration
    }
    
    // Function to calculated overlapped ranges from session
    func calculateOverlappingRanges(sessions: [RadioSession]) -> [ClosedRange<Date>] {
           var overlappingRanges: [ClosedRange<Date>] = []
           
           // Step 1: Sort sessions by start time
           let sortedSessions = sessions.sorted { $0.startTime < $1.startTime }
           
           // Step 2: Identify overlaps
           var previousSession: RadioSession? = nil
           
           for session in sortedSessions {
               if let prev = previousSession {
                   if session.startTime <= prev.endTime {
                       // There is overlap
                       let overlapStart = max(prev.startTime, session.startTime)
                       let overlapEnd = min(prev.endTime, session.endTime)
                       overlappingRanges.append(overlapStart...overlapEnd)
                   }
               }
               previousSession = session
           }
           
           return overlappingRanges
       }
    
    // Function to consolidates overlapping sessions into single duration blocks.
    func mergeOverlappingSessions(_ sessions: [RadioSession]) -> [RadioSession] {
            guard !sessions.isEmpty else { return [] }
            
            let sortedSessions = sessions.sorted(by: { $0.startTime < $1.startTime })
            var merged: [RadioSession] = []
            
            var currentSession = sortedSessions[0]
            
            for session in sortedSessions[1...] {
                if session.startTime <= currentSession.endTime { // Overlapping sessions
                    currentSession.endTime = max(currentSession.endTime, session.endTime)
                } else {
                    merged.append(currentSession)
                    currentSession = session
                }
            }
            merged.append(currentSession) // Add the last session
            return merged
        }
}

