//
//  RadioStreamingSessionRouterTests.swift
//  RadioSessionTrackingTests
//
//  Created by Vibha Mangrulkar on 2024/09/19.
//

import SwiftUI
import XCTest
@testable import RadioSessionTracking

class RadioStreamingSessionRouterTests: XCTestCase {
    
    var router: RadioStreamingSessionRouter!
    
    override func setUp() {
        super.setUp()
        router = RadioStreamingSessionRouter()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    func testNavigateToAddSessionView() {
        let mockView = MockView()
        let addSessionView = router.navigateToAddSessionView(from: mockView)
        XCTAssertNotNil(addSessionView)
        XCTAssertTrue(addSessionView is AddSessionView)
                if let addSessionView = addSessionView as? AddSessionView {
            XCTAssertNotNil(addSessionView.presenter)
            XCTAssertTrue(addSessionView.presenter is RadioStreamingSessionPresenter)
        }
    }
}

struct MockView: View {
    var body: some View {
        Text("Mock View")
    }
}
