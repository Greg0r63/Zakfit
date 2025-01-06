//
//  ButtonsView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct ButtonsView: View {
    let text: String
    let destinationType: DestinationType
    var body: some View {
        NavigationLink(destination: destinationView(type: destinationType)) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func destinationView(type: DestinationType) -> some View {
        switch type {
        case .signup:
            RegisterView()
        case .register:
            ConnectionView()
        case .login:
            ProfileView()
        }
    }
}

enum DestinationType {
    case login
    case signup
    case register
}
