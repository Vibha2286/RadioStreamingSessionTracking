//
//  AddSessionView.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

struct AddSessionView: View {
    
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600) // 1 hour later
    
    var presenter: RadioStreamingSessionPresenter
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Start Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    DatePicker(
                        "",
                        selection: $startTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Text("End Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    DatePicker(
                        "",
                        selection: $endTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                Button(action: {
                    let sessionID = UUID().uuidString
                    presenter.addSession(id: sessionID, startTime: startTime, endTime: endTime)
                }) {
                    Text("Add Session")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}
