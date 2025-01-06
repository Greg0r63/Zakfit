//
//  UpdateUserView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 16/12/2024.
//

import SwiftUI

struct UserUpdateView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = "".lowercased()
    @State private var password: String = ""
    @State private var size: String = ""
    @State private var weight: String = ""
    
    @Binding var showEditProfile: Bool
    
    @State private var showAlert: Bool = false
    var body: some View {
        VStack {
            Text("Mettre à jour les informations")
                .font(.largeTitle)
                .padding()
            
            Form {
                TextField(userViewModel.currentUser?.firstName ?? "Prénom", text: $firstName)
                    .autocorrectionDisabled()
                TextField(userViewModel.currentUser?.lastName ?? "Nom", text: $lastName)
                    .autocorrectionDisabled()
                TextField(userViewModel.currentUser?.email ?? "Email", text: $email)
                    .autocorrectionDisabled()
                TextField("Mot de passe", text: $password)
                    .textContentType(.password)
                
                // Champ pour la taille
                TextField("\(userViewModel.currentUser?.size ?? 0)", text: $size)
                    .keyboardType(.decimalPad)
                
                // Champ pour le poids
                TextField("\(userViewModel.currentUser?.weight ?? 0)", text: $weight)
                    .keyboardType(.decimalPad)
                
                Button(action: {
                        updateUser()
                    if showAlert == false {
                        showEditProfile = false
                    }
                }) {
                    Text("Mettre à jour")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .onAppear {
            userViewModel.fetchUserData()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erreur"),
                message: Text("Veuillez renseigner au moins un champ pour mettre à jour."),
                dismissButton: .default(Text("OK"))
            )
        }

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func updateUser() {
        var updateRequest = UpdatedUser()
        
        if firstName.isEmpty && lastName.isEmpty && email.isEmpty && password.isEmpty && size.isEmpty && weight.isEmpty {
            showAlert = true
        } else if !email.isEmpty && !isValidEmail(email) {
            print("Format de l'email invalide")
            return
        }
        if showAlert == false && !firstName.isEmpty || !lastName.isEmpty || !email.isEmpty || !password.isEmpty || !size.isEmpty || !weight.isEmpty {
            if !firstName.isEmpty {
                        updateRequest.firstName = firstName
            }
            if !lastName.isEmpty {
                        updateRequest.lastName = lastName
            }
            if !email.isEmpty {
                let lowercaseEmail = email.lowercased()
                updateRequest.email = lowercaseEmail
            }
            if !password.isEmpty {
                        updateRequest.password = password
            }
            if let sizeValue = Double(size), !size.isEmpty {
                        updateRequest.size = sizeValue
            }
            if let weightValue = Double(weight), !weight.isEmpty {
                        updateRequest.weight = weightValue
            }
            userViewModel.updateUser(user: updateRequest)
        }
    }
}
