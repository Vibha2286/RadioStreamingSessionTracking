//
//  RadioStreamingSessionPresenterTests.swift
//  RadioSessionTrackingTests
//
//  Created by Vibha Mangrulkar on 2024/09/19.
//

import XCTest
@testable import RadioSessionTracking

class RadioStreamingSessionPresenterTests: XCTestCase {
    
    var presenter: RadioStreamingSessionPresenter!
    var mockInteractor: RadioStreamingSessionInteractor!
    var mockRouter: RadioStreamingSessionRouter!
    
    override func setUp() {
        super.setUp()
        mockInteractor = RadioStreamingSessionInteractor()
        mockRouter = RadioStreamingSessionRouter()
        presenter = RadioStreamingSessionPresenter(interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testFetchSessions() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(7200), endTime: Date().addingTimeInterval(10800))
        mockInteractor.sessions = [session1, session2]
        
        presenter.fetchSessions()
        
        XCTAssertEqual(presenter.sessions.count, 2)
        XCTAssertEqual(presenter.sessions[0].id, session1.id)
        XCTAssertEqual(presenter.sessions[1].id, session2.id)
    }
    
    func testAddSession() {
        let newSessionId = "3"
        let startTime = Date()
        let endTime = Date().addingTimeInterval(3600)
        
        presenter.addSession(id: newSessionId, startTime: startTime, endTime: endTime)
        
        XCTAssertEqual(mockInteractor.sessions.count, 1)
        XCTAssertEqual(mockInteractor.sessions[0].id, newSessionId)
        XCTAssertEqual(mockInteractor.sessions[0].startTime, startTime)
        XCTAssertEqual(mockInteractor.sessions[0].endTime, endTime)
        XCTAssertEqual(presenter.sessions.count, 1)
    }
    
    func testRemoveSession() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        mockInteractor.sessions = [session1]
        
        presenter.removeSession(id: session1.id)
        
        XCTAssertEqual(mockInteractor.sessions.count, 0)
        XCTAssertEqual(presenter.sessions.count, 0)
    }
    
    func testFetchOverlappedSession() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(1800), endTime: Date().addingTimeInterval(5400))
        mockInteractor.sessions = [session1, session2]
        
        let overlappedRanges = presenter.fetchOverlappedSession(sessions: mockInteractor.sessions)
        
        XCTAssertEqual(overlappedRanges.count, 1) // There should be one overlapping range
    }
    
    func testFetchEffectiveDuration() {
        let session1 = RadioSession(id: "1", startTime: Date(), endTime: Date().addingTimeInterval(3600))
        let session2 = RadioSession(id: "2", startTime: Date().addingTimeInterval(1800), endTime: Date().addingTimeInterval(5400))
        mockInteractor.sessions = [session1, session2]
        
        let effectiveSessions = presenter.fetchEffectiveDucration(mockInteractor.sessions)
        
        XCTAssertEqual(effectiveSessions.count, 1) // There should be one effective session after merging
    }
}
