//
//  Tabvie.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var mainTitle = "Tab1"
    var body: some View {
        TabView {
            Tab("Profile", systemImage: "person") {
                ProfileView()
            }
        }
    }
}

#Preview {
    TabBarView()
}
