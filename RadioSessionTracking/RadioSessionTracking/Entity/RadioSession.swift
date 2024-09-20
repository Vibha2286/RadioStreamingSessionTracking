//
//  RadioSession.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

struct RadioSession: Identifiable, Equatable {
    
    var id: String
    var startTime: Date
    var endTime: Date
    
    init(id: String, startTime: Date, endTime: Date) {
        guard startTime <= endTime else {
            fatalError("Invalid session: startTime must be before endTime.")
        }
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
    
    // Automatic synthesis of Equatable
    static func == (lhs: RadioSession, rhs: RadioSession) -> Bool {
        return lhs.id == rhs.id &&
        lhs.startTime == rhs.startTime &&
        lhs.endTime == rhs.endTime
    }
}
