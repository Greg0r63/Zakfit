//
//  AuthManager.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 11/12/2024.
//

import Foundation

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init () {
        checkTokenValidity()
    }
    
    func checkTokenValidity() {
        if let token = KeychainManager.getTokenFromKeychain(), isTokenValid(token: token) {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func isTokenValid(token: String) -> Bool {
            guard let expirationDate = KeychainManager.getTokenExpirationDate(from: token) else {
                print("Échec : impossible de récupérer la date d'expiration du token")
                return false
            }

            if Date() < expirationDate {
                print("Le token est valide")
                return true
            } else {
                print("Le token a expiré")
                return false
            }
        }
    
    func logout() {
        KeychainManager.deleteTokenFromKeychain()
    }
    
    func verifyToken() {
        
    }
}
