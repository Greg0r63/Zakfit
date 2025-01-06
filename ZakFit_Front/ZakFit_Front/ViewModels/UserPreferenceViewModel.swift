//
//  UserPreferenceViewModel.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 18/12/2024.
//

import Foundation

class UserPreferenceViewModel: ObservableObject {
    @Published var userPreferences: [UserPreference] = []
    
    func fetchActivePreferenceForUser() {
            guard let url = URL(string: "http://127.0.0.1:8080/userpref/pref") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Récupération du token
            guard let token = KeychainManager.getTokenFromKeychain() else {
                print("Pas de token dans le keychain")
                return
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Requête réseau
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Erreur réseau : \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    print("Token expiré")
                    return
                }
                
                guard let data = data else {
                    print("Aucune donnée reçue")
                    return
                }
                
                do {
                    let decodedUserPreferences = try JSONDecoder().decode([UserPreference].self, from: data)
                    DispatchQueue.main.async {
                        self.userPreferences = decodedUserPreferences
                    }
                } catch {
                    print("Erreur de décodage : \(error)")
                }
            }.resume()
        }
    
    func updatePreference(preferenceID: UUID, isActive: Bool) {
        guard let url = URL(string: "http://127.0.0.1:8080/userpref") else {
            print("URL invalide")
            return
        }
        
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("Pas de token dans le keychain")
            return
        }
        
        let updateRequest = UpdatePreferenceRequest(preferenceID: preferenceID, isActive: isActive)
        
        guard let jsonData = try? JSONEncoder().encode(updateRequest) else {
            print("Erreur lors de l'encodage JSON")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête : \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Mise à jour réussie")
            } else {
                print("Erreur : \(response.debugDescription)")
            }
        }.resume()
    }

    }
