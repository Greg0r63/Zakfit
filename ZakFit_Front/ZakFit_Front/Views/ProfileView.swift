//
//  ProfileView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @ObservedObject var authManager: AuthManager = AuthManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Fond")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("Profil")
                            .font(.system(size: 40))
                            .padding()
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        HStack {
                            Text(userViewModel.currentUser?.firstName ?? "Prénom")
                            Text(userViewModel.currentUser?.lastName ?? "Nom")
                        }
                        Text(userViewModel.currentUser?.email ?? "Email")
                    }
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            // ProfileSections folder
                            InformationSectionView()
                            
                            // ProfileSections folder
                            HealthGoalSection()
                            
                            // ProfileSections folder
                            AlimentaryPreferencesSection()
                            
                            Section(header: CustomSectionHeader()) {
                                Button(action: {
                                    logout()
                                }, label: {
                                    HStack {
                                        Image(systemName: "arrowshape.turn.up.left")
                                            .foregroundStyle(.red)
                                        Text("Se déconnecter")
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                })
                            }
                        }
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.async {
                    userViewModel.fetchUserData()
                }
            }
        }
    }
    
    func logout() {
        authManager.logout()
    }
}

#Preview {
    ProfileView()
}
