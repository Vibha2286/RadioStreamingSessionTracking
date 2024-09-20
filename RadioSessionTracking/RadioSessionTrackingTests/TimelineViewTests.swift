//
//  TimelineViewTests.swift
//  RadioSessionTrackingTests
//
//  Created by Vibha Mangrulkar on 2024/09/19.
//

import XCTest
@testable import RadioSessionTracking

class TimelineViewTests: XCTestCase {
    
    var mockInteractor: RadioStreamingSessionInteractor!
    var mockRouter: RadioStreamingSessionRouter!
    
    override func setUp() {
        super.setUp()
        mockInteractor = RadioStreamingSessionInteractor()
        mockRouter = RadioStreamingSessionRouter()
    }
    
    override func tearDown() {
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testTotalSessionDuration() {
        let presenter = RadioStreamingSessionPresenter(interactor: mockInteractor, router: mockRouter)
        presenter.sessions = [
            RadioSession(id: "1", startTime: date("09:00"), endTime: date("10:00")),
            RadioSession(id: "2", startTime: date("10:00"), endTime: date("12:00")),
            RadioSession(id: "3", startTime: date("12:00"), endTime: date("15:00"))
        ]
        
        let timelineView = TimelineView(presenter: presenter)
        let totalDuration = timelineView.presenter.totalSessionDuration(session: presenter.sessions)
        
        XCTAssertEqual(totalDuration, "6h 0m")
    }
    
    private func date(_ time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time)!
    }
}
