//
//  UserViewModel.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 08/12/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    func fetchUsers() {
        guard let url = URL(string: "http://127.0.0.1:8080/users") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                        print("data décodées")
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    
    func fetchUserData() {
        // Configurer l'url
        let url: URL = URL(string: "http://127.0.0.1:8080/users/profile")!
        var request = URLRequest(url: url)
        
        // Configurer la requete
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Recupere le token depuis le keychain
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("Pas de token dans le keychain")
            return
        }
        // Ajout du token dans le header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Lancement de la requete
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                print("Error : \(String(describing: error?.localizedDescription))")
                return
            }
            
            if httpResponse.statusCode == 401 {
                print("Token expiré")
                return
            }
            
            guard let data = data else {
                print("Réponse invalide")
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
            } catch {
                print("Erreur de décodage de l'utilisateur : \(error)")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
            
        }.resume()
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        // Configurer l'url
        let url: URL = URL(string: "http://127.0.0.1:8080/users/")!
        var request = URLRequest(url: url)
        
        // Configurer la requete
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajouter les identifiants dans le body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["firstName": firstName, "lastName": lastName,"email": email, "password": password])
        }
        catch {
            fatalError("Erreur de sérialisation en JSON")
        }
        
        // Executer la requete
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
            
            if let responseHttp = response as? HTTPURLResponse, responseHttp.statusCode == 409 {
                print("Email déjà utilisé")
                return
            }
            print("Inscription réussie !")
        }.resume()
    }
    
    func updateUser(user: UpdatedUser) {
        // Configurer l'url
        let url: URL = URL(string: "http://127.0.0.1:8080/users")!
        var request = URLRequest(url: url)
        
        // Configurer la requete
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Recupere le token depuis le keychain
        guard let token = KeychainManager.getTokenFromKeychain() else {
            print("Pas de token dans le keychain")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
        } catch {
            fatalError("Erreur de sérialisation en JSON")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse else {
                print("Mise à jour impossible :\(String(describing: error))")
                return
            }
            if response.statusCode == 200 {
                print("Mise à jour réussie !")
            } else if response.statusCode == 409 {
                print("Email déjà utilisé")
            }
        }.resume()
    }
    
    func login(email: String, password: String) {
        let url: URL = URL(string: "http://127.0.0.1:8080/users/login")!
        var request = URLRequest(url: url)
        
        // Configurer la requête
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode les identifiants
        let authData = (email + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        // Executer la requete
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let responseHttp = response as? HTTPURLResponse, responseHttp.statusCode == 200, let data = data else {
                print("Error : Email ou mot de passe invalide")
                return
            }
            print("Authentification réussie")
            
            do {
                // Decode le token
                // Récupère la réponse du serveur à notre requête (data) et la décode en une instance JWToken
                let token = try JSONDecoder().decode(JWToken.self, from: data)
                
                // Sauvegarder le token dans le keychain
                KeychainManager.saveTokenToKeychain(token: token.value)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                print("Il y a une erreur de decodage du token")
            }
        }.resume()
    }
}
