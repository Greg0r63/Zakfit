//
//  EditPreferencesView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 16/12/2024.
//

import SwiftUI

struct EditPreferencesView: View {
    @StateObject private var userPreferenceVM: UserPreferenceViewModel = UserPreferenceViewModel()
    @StateObject private var alimentaryPreferenceVM: AlimentaryPreferenceViewModel = AlimentaryPreferenceViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("Modifier les Préférences")) {
                ForEach(alimentaryPreferenceVM.alimentaryPreferences) { preference in
                    HStack {
                        Text(preference.name)
                        Spacer()
                        Toggle(
                            isOn: preferenceBinding(for: preference)
                        ) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationTitle("Préférences Alimentaires")
        .onAppear {
            alimentaryPreferenceVM.fecthAlimentaryPreferences()
            userPreferenceVM.fetchActivePreferenceForUser()
        }
    }
    
    private func preferenceBinding(for preference: AlimentaryPreference) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                userPreferenceVM.userPreferences.contains { $0.id == preference.id }
            },
            set: { newValue in
                updatePreference(preferenceID: preference.id, isActive: newValue)
            }
        )
    }
    
    private func updatePreference(preferenceID: UUID, isActive: Bool) {
        userPreferenceVM.updatePreference(preferenceID: preferenceID, isActive: isActive)
    }
}


