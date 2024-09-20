//
//  ContentView.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/19.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var presenter = RadioStreamingSessionPresenter(
        interactor: RadioStreamingSessionInteractor(),
        router: RadioStreamingSessionRouter())
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Spacer()
                
                Text("Radio Session")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                
                // Add Session Form
                AddSessionView(presenter: presenter)
                
                VStack(alignment: .leading) {
                    // Timeline Display
                    Text("Session Timeline")
                        .font(.title2)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    TimelineView(presenter: presenter)
                }
                
                // Session List
                Text("Sessions")
                    .font(.title2)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                RadioStreamingSessionView(presenter: presenter)
                
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
        }.background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom))
    }
}
