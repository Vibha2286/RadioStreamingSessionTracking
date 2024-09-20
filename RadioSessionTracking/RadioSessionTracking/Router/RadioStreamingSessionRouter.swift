//
//  RadioStreamingSessionRouter.swift
//  RadioSessionTracking
//
//  Created by Vibha Mangrulkar on 2024/09/18.
//

import SwiftUI

final class RadioStreamingSessionRouter {
    
    func navigateToAddSessionView(from view: some View) -> some View {
        let presenter = RadioStreamingSessionPresenter(interactor: RadioStreamingSessionInteractor(), router: self)
        return AddSessionView(presenter: presenter)
    }
}
