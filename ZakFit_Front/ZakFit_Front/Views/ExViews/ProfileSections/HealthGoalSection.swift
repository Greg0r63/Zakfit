//
//  HealthGoalSection.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 16/12/2024.
//

import SwiftUI

struct HealthGoalSection: View {
    
    // Objectif de santé
    @State private var healthGoal = "Maintenir mon poids"
    let healthGoals = ["Perdre du poids", "Maintenir mon poids", "Prendre de la masse musculaire"]
    
    var body: some View {
        Section(header: CustomSectionHeader(text: "Objectif de santé")) {
            HStack {
                Text("Objectif")
                Spacer()
                Picker("Objectif", selection: $healthGoal) {
                    ForEach(healthGoals, id: \.self) { goal in
                        Text(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HealthGoalSection()
}
