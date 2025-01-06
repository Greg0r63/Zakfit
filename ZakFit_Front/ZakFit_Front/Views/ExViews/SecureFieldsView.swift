//
//  SecureFieldsView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct SecureFieldsView: View {
    var iconName: String
    var name: String
    @Binding var text: String
    @State private var showPassword: Bool = false

    var body: some View {
        HStack {
            Image(systemName: iconName)
            SecureField(name, text: $text)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
        .padding(.horizontal, 30)
    }
}

struct SecureFieldWithToggle: View {
    @Binding var text: String
    let name: String
    let icon: String
    
    // État pour afficher ou masquer le texte
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            
            // Champ de texte qui alterne entre un `TextField` et un `SecureField`
            if showPassword {
                TextField(name, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                SecureField(name, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Bouton pour afficher/masquer le texte
            Button(action: {
                showPassword.toggle()
            }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .padding(.horizontal, 30)
    }
}
