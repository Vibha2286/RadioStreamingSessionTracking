//
//  RadioStreamingSessionView.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

struct RadioStreamingSessionView: View {
    
    @ObservedObject var presenter: RadioStreamingSessionPresenter
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(presenter.sessions) { session in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Session")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("From: \(session.startTime.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Text("To: \(session.endTime.formatted())")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Check if the session is overlapping and display an appropriate label
                        if isSessionOverlapping(session) {
                            Text("Overlapping Session")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                    Spacer()
                    Button(action: {
                        presenter.removeSession(id: session.id)
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(16)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

private extension RadioStreamingSessionView {
    // Check if the session overlaps with other sessions
    private func isSessionOverlapping(_ session: RadioSession) -> Bool {
        for otherSession in presenter.sessions {
            if otherSession.id != session.id &&
                otherSession.startTime < session.endTime &&
                otherSession.endTime > session.startTime {
                return true
            }
        }
        return false
    }
}
