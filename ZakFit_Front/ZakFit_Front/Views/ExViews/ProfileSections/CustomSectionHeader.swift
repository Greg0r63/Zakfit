//
//  CustomSectionHeader.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 13/12/2024.
//

import SwiftUI

struct CustomSectionHeader: View {
    var text: String = ""
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20).bold())
                .padding(.vertical, 10)
                .padding(.leading, 20)
                .foregroundStyle(.white)
            Spacer()
        }
        .background(.orange)
    }
}
