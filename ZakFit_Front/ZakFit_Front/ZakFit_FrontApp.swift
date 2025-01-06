//
//  ZakFit_FrontApp.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 05/12/2024.
//

import SwiftUI
import SwiftData

@main
struct ZakFit_FrontApp: App {
    @StateObject private var authManager: AuthManager = AuthManager()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
