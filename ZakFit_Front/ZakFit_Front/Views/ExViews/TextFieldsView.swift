//
//  FieldsView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct TextFieldsView: View {
    
    var iconName: String
    var name: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            TextField(name, text: $text)
        }
        .autocorrectionDisabled()
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
        .padding(.horizontal, 30)
    }
}
