//
//  SwiftUIView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 05/12/2024.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var viewModel = UserViewModel()
    @EnvironmentObject var authManager: AuthManager
    @State var email = ""
    @State var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String = ""
    @State private var isConnected: Bool = false
    let registerView = RegisterView()
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .padding(.top, 30)
                    
                Spacer()
                    
                VStack {
                    TextFieldsView(iconName: "envelope", name: "email", text: $email)
                        .padding(.vertical)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        
                    VStack(alignment: .leading) {
                        SecureFieldWithToggle(text: $password, name: "Mot de passe", icon: "lock")
                        HStack {
                            Spacer()
                            Button(action: {
                                    
                            }) {
                                Text("Mot de passe oublié ?")
                                    .foregroundColor(.black)
                                    .underline()
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    
                    errorManager()
                    
                }, label: {
                    Text("Se connecter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                })
                .padding(.horizontal, 30)
                .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                    TabBarView()
                }
                    
//                ButtonsView(text: "Se connecter", destinationType: .login)
                    
                Text("Pas encore inscrit ?")
                    .font(.title)
                    
                ButtonsView(text: "S'inscrire", destinationType: .signup)
                    
                Spacer()
            }
            .background(
                Image("Fond_D_ecran")
                    .resizable()
                    .ignoresSafeArea()
            )
        }
    }
    
    func login() {
        viewModel.login(email: email.lowercased(), password: password)
    }
}

extension ConnectionView {
    func errorManager() {
        // Validation des champs
        if email.isEmpty && password.isEmpty {
            print("Veuillez renseigner votre adresse e-mail et votre mot de passe.")
        } else if email.isEmpty {
            print("Veuillez renseigner votre adresse e-mail.")
        } else if !registerView.isValidEmail(email) {
            print("Veuillez entrer une adresse e-mail valide.")
        } else if password.isEmpty {
            print("Veuillez renseigner votre mot de passe.")
        } else {
            login()
            print("Connecté")
        }
    }
}

#Preview {
    ConnectionView()
}
