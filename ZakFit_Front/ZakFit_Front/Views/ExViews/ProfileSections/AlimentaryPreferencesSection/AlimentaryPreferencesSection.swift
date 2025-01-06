//
//  AlimentaryPreferencesSection.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 16/12/2024.
//

import SwiftUI

struct AlimentaryPreferencesSection: View {
    
    // Préférences alimentaires
    @StateObject var userPreferencesViewModel = UserPreferenceViewModel()
    
    var body: some View {
        Section(header: CustomSectionHeader(text: "Préférences alimentaires")) {
            Group {
                ForEach(userPreferencesViewModel.userPreferences) { preference in
                    HStack {
                        Text(preference.name)
                            .padding(.vertical, 5)
                        Spacer()
                    }
                    if preference.id != userPreferencesViewModel.userPreferences.last?.id {
                        Divider()
                    }
                }
                
                Divider()
                
                HStack {
                    NavigationLink(destination: EditPreferencesView()) {
                        HStack {
                            Text("Modifier les préférences")
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            userPreferencesViewModel.fetchActivePreferenceForUser()
        }
    }
}

#Preview {
    AlimentaryPreferencesSection()
}
