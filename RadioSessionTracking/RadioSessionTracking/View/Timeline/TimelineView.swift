//
//  TimelineView.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

struct TimelineView: View {
    
    @StateObject var presenter = RadioStreamingSessionPresenter(
        interactor: RadioStreamingSessionInteractor(),
        router: RadioStreamingSessionRouter())
    
    var body: some View {
        VStack {
            HStack {
                Text("Timeline")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("Total: \(presenter.totalSessionDuration(session: presenter.sessions))")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text("Effective: \(effectiveSessionDuration())")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 0) { // Ensure no spacing between items
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 2)
                                .offset(x: 0, y: 20) // Adjust offset for bars and line
                            
                            ForEach(presenter.sessions) { session in
                                let startOffset = CGFloat(session.startTime.timeIntervalSince(presenter.sessions.first!.startTime)) / 3600 * 100
                                let barWidth = CGFloat(session.endTime.timeIntervalSince(session.startTime)) / 3600 * 100
                                
                                // Determine if session overlaps and choose color accordingly
                                let gradientColors = isSessionOverlapping(session)
                                    ? [Color.red, Color.orange] // Overlapping sessions are red-orange
                                    : [Color.blue, Color.purple] // Non-overlapping sessions are blue-purple
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: gradientColors),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .frame(width: barWidth, height: 20)
                                    .offset(x: startOffset)
                                    .scaleEffect(isSessionOverlapping(session) ? 1.1 : 1.0, anchor: .leading) // Scale effect for overlapping sessions
                                    .animation(.easeInOut(duration: 0.9), value: presenter.sessions) // Animate on session change
                                    .overlay(
                                        VStack {
                                            Text(formatTime(session.startTime))
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color.black.opacity(0.7))
                                                .cornerRadius(4)
                                            Spacer()
                                            Text(formatTime(session.endTime))
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Color.black.opacity(0.7))
                                                .cornerRadius(4)
                                        }
                                        .offset(x: startOffset + barWidth / 2 - 60, y: -30)
                                    )
                            }
                        }
                        .frame(width: timelineWidth, height: 60) // Adjust width based on content
                        .padding(.top, 40) // Top padding
                    }
                    .padding(10)
                    .frame(width: max(timelineWidth, 1000), height: 120) // Ensure width is at least 1000 if the content is smaller
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.yellow.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding()
    }
}

private extension TimelineView {
    
    private func effectiveSessionDuration() -> String {
        let mergedSessions = presenter.fetchEffectiveDucration(presenter.sessions)
        let effectiveDuration = mergedSessions.reduce(0) { total, session in
            total + session.endTime.timeIntervalSince(session.startTime)
        }
        let hours = Int(effectiveDuration / 3600)
        let minutes = Int((effectiveDuration.truncatingRemainder(dividingBy: 3600)) / 60)
        return "\(hours)h \(minutes)m"
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private var timelineWidth: CGFloat {
        guard let firstSession = presenter.sessions.min(by: { $0.startTime < $1.startTime }),
              let lastSession = presenter.sessions.max(by: { $0.endTime < $1.endTime }) else {
            return 0
        }
        return CGFloat(lastSession.endTime.timeIntervalSince(firstSession.startTime)) / 3600 * 100
    }
    
    private func isSessionOverlapping(_ session: RadioSession) -> Bool {
        for range in presenter.fetchOverlappedSession(sessions: presenter.sessions) {
            if session.startTime <= range.upperBound && session.endTime >= range.lowerBound {
                return true
            }
        }
        return false
    }
}
