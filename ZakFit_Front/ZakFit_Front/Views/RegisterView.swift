//
//  RegisterView.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 06/12/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = UserViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordMismatchAlert = false
    @State var isValidEmail: Bool = false
    @State private var errorMessage = ""

    var body: some View {
            VStack(spacing: 40) {
                Text("Inscription")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                // Champ Prénom
                TextFieldsView(iconName: "person", name: "Prénom", text: $firstName)
                
                // Champ Nom
                TextFieldsView(iconName: "person", name: "Nom", text: $lastName)
                
                // Champ Email
                TextFieldsView(iconName: "envelope", name: "email", text: $email)
                    .autocapitalization(.none)
                
                // Champ Mot de passe
                SecureFieldsView(iconName: "lock", name: "Mot de passe", text: $password)
                
                // Champ Confirmation du mot de passe
                SecureFieldsView(iconName: "lock.fill", name: "Confirmer mot de passe", text: $confirmPassword)
                
                // Bouton S'inscrire
                Button(action: {
                    let isValid = validateFields()
                    if isValid {
                        register()
                        resetFields()
                    } else {
                        print(errorMessage)
                    }
                }) {
                    Text("S'inscrire")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .alert(isPresented: $showPasswordMismatchAlert) {
                    Alert(
                        title: Text("Erreur"),
                        message: Text("Les mots de passe ne correspondent pas."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .background(Image("Fond_D_ecran")
            .resizable()
            .ignoresSafeArea())
    }
    
    func register() {
        viewModel.register(firstName: firstName, lastName: lastName, email: email.lowercased(), password: password)
    }
}

extension RegisterView {
    func validateFields() -> Bool {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Tous les champs doivent être remplis."
            return false
        }
            
        // Validation de l'email
        if !isValidEmail(email) {
            errorMessage = "L'email n'est pas valide."
            return false
        }
            
        // Vérification du mot de passe
        if password != confirmPassword {
            errorMessage = "Les mots de passe ne correspondent pas."
            return false
        } else if password.count < 8 {
            errorMessage = "Le mot de passe doit faire au minimum 8 caractères."
        }
            
        errorMessage = "" // Réinitialiser le message d'erreur si tout est valide
        return true
    }
    
    func resetFields() {
            firstName = ""
            lastName = ""
            email = ""
            password = ""
            confirmPassword = ""
        }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

#Preview {
    RegisterView()
}
