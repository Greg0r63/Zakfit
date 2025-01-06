//
//  InformationSection.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 16/12/2024.
//

import SwiftUI

struct InformationSectionView: View {
    
    @StateObject private var userViewModel = UserViewModel()
    
    @State var showEditProfile: Bool = false
    
    var body: some View {
        Section(header: CustomSectionHeader(text: "Informations personnelles")) {
            Group {
                HStack {
                    Text("Taille : \(userViewModel.currentUser?.size ?? 0)")
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    Text("Poids : \(userViewModel.currentUser?.weight ?? 0)")
                    Spacer()
                }
                
                Divider()
                
                Button(action: {
                    showEditProfile = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                        Text("Modifier le profil")
                        Spacer()
                    }
                }
                .sheet(isPresented: $showEditProfile) {
                    UserUpdateView(showEditProfile: $showEditProfile)
                }
            }
            .padding(.horizontal)
            .onAppear {
                userViewModel.fetchUserData()
            }
        }
    }
}

#Preview {
    InformationSectionView()
}
