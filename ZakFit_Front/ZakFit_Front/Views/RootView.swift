//
//  RootView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 11/12/2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var autManager: AuthManager
    var body: some View {
        Group {
            if autManager.isLoggedIn {
                TabBarView()
            } else {
                ConnectionView()
            }
        }
    }
}
