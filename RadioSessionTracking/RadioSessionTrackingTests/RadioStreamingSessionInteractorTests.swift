//
//  RadioStreamingSessionInteractorTests.swift
//  RadioSessionTrackingTests
//
//  Created by Vibha Mangrulkar on 2024/09/19.
//

import XCTest
@testable import RadioSessionTracking

class RadioStreamingSessionInteractorTests: XCTestCase {
    
    var interactor: RadioStreamingSessionInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = RadioStreamingSessionInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testGetSessions() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        interactor.addSession(id: session1.id, startTime: session1.startTime, endTime: session1.endTime)
        let sessions = interactor.getSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.id, session1.id)
    }
    
    func testAddSession() {
        let sessionToAdd = RadioSession(id: "2", startTime: Date().addingTimeInterval(3600), endTime: Date().addingTimeInterval(7200))
        interactor.addSession(id: sessionToAdd.id, startTime: sessionToAdd.startTime, endTime: sessionToAdd.endTime)
        XCTAssertEqual(interactor.getSessions().count, 1)
        XCTAssertEqual(interactor.getSessions().first?.id, sessionToAdd.id)
    }
    
    func testRemoveSession() {
        let sessionToRemove = RadioSession(id: "3", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        interactor.addSession(id: sessionToRemove.id, startTime: sessionToRemove.startTime, endTime: sessionToRemove.endTime)
        interactor.removeSession(id: sessionToRemove.id)
        XCTAssertTrue(interactor.getSessions().isEmpty)
    }
    
    func testCalculateEffectiveStreamingDuration_NoOverlap() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600)) // 1 hour
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(10800)) // 1 hour
        interactor.addSession(id: session1.id, startTime: session1.startTime, endTime: session1.endTime)
        interactor.addSession(id: session2.id, startTime: session2.startTime, endTime: session2.endTime)
        let totalDuration = interactor.calculateEffectiveStreamingDuration(sessions: interactor.getSessions())
        XCTAssertEqual(totalDuration, 7200) // 2 hours
    }
    
    func testCalculateEffectiveStreamingDuration_WithOverlap() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600)) // 1 hour
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(1800), endTime: Date().addingTimeInterval(5400)) // 3 hours, overlaps 30 minutes
        interactor.addSession(id: session1.id, startTime: session1.startTime, endTime: session1.endTime)
        interactor.addSession(id: session2.id, startTime: session2.startTime, endTime: session2.endTime)
        let totalDuration = interactor.calculateEffectiveStreamingDuration(sessions: interactor.getSessions())
        XCTAssertEqual(totalDuration, 3600 + 1800) // 4.5 hours - 0.5 hours overlap = 4 hours
    }
    
    func testMergeOverlappingSessions() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(1800), endTime: Date().addingTimeInterval(5400))
        let session3 = RadioSession(id: "3", startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(10800))
        interactor.addSession(id: session1.id, startTime: session1.startTime, endTime: session1.endTime)
        interactor.addSession(id: session2.id, startTime: session2.startTime, endTime: session2.endTime)
        interactor.addSession(id: session3.id, startTime: session3.startTime, endTime: session3.endTime)
        
        let mergedSessions = interactor.mergeOverlappingSessions(interactor.getSessions())
        XCTAssertEqual(mergedSessions.count, 2) // One merged session and one standalone session
        XCTAssertEqual(mergedSessions[0].startTime, session1.startTime)
        XCTAssertEqual(mergedSessions[0].endTime, session2.endTime) // The merged session's end time
        XCTAssertEqual(mergedSessions[1].startTime, session3.startTime)
        XCTAssertEqual(mergedSessions[1].endTime, session3.endTime)
    }
}
