//
//  KeyChainManager.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 08/12/2024.
//

import Foundation
import Security

/**
 Documentation de la structure KeychainManager
 
 Cette structure contient plusieurs qui représentent un trousseau servant à gérer le token reçu en réponse de l'API
 
 Sauvegardez le token reçu dans le trousseau en utilisant KeychainManager.saveToKeychain(token)
 Récupérez le token stocké en utilisatn KeychainManager.getTokenFromKeychain()
 Supprimez le token stocké en utilisant KeychainManager.deleteTokenFromKeychain()
 Récupérez la date d'expiration du token stocké en utilisant KeychaiManager.getTokenExpirationDate(from token)
 
 */

struct KeychainManager {
    
    /**
     Méthode pour sauvegarder le token
     - Parameters
        - token: token reçu lors de la réponse de l'API
     - Returns: Rien
     */
    static func saveTokenToKeychain(token: String) {
        // Convertir le token en data
        guard let tokenData = token.data(using: .utf8) else {
            print("Erreur encodage token")
            return
        }
        
        // Créer un dictionnaire de requete pour le trousseau
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "token",
            kSecValueData as String: tokenData
        ]
        
        // Supprimer la clé existante
        SecItemDelete(query as CFDictionary)
        
        // Ajouter le token dans le trousseau
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /**
     Méthode pour récupérer le token

     - Returns: le token sous forme de chaine de caractères
     */
    static func getTokenFromKeychain() -> String? {
        // Configurer la requête pour trouver l'élément dans le trousseau
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "token",
            kSecReturnData as String: true
        ]
        
        // Rechercher l'élément
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Décoder les données en chaîne de caractères
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /**
     Méthode pour supprimer le token

     - Returns: Rien
     */
    static func deleteTokenFromKeychain() {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "token" // Nom du compte utilisé pour stocker le token
            ]

            let status = SecItemDelete(query as CFDictionary)
            if status == errSecSuccess {
                print("Token supprimé du Keychain avec succès")
            } else if status == errSecItemNotFound {
                print("Aucun token trouvé dans le Keychain")
            } else {
                print("Erreur lors de la suppression du token : \(status)")
            }
        }
    
    /**
     Méthode pour sauvegarder le token
     - Parameters
        - token: token stocké dans le trousseau
     - Returns: la date d'expiration du token
     */
    static func getTokenExpirationDate(from token: String) -> Date? {
            let parts = token.split(separator: ".")
            guard parts.count == 3 else {
                print("Le token n'est pas au format JWT valide")
                return nil
            }

            let payload = parts[1]
            guard let payloadData = Data(base64Encoded: String(payload)) else {
                print("Échec de décodage de la charge utile du token")
                return nil
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
                   let expiration = json["expiration"] as? TimeInterval {
                    return Date(timeIntervalSince1970: expiration)
                } else {
                    print("Impossible de lire la date d'expiration du token")
                    return nil
                }
            } catch {
                print("Erreur lors de la conversion JSON : \(error)")
                return nil
            }
        }
    
    static func getValue(from token: String, forKey key: String) -> Any? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("Le token n'est pas au format JWT valide")
            return nil
        }

        let payload = parts[1]
        guard let payloadData = Data(base64Encoded: String(payload)) else {
            print("Échec de décodage de la charge utile du token")
            return nil
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
                return json[key] // Retourne la valeur associée à la clé
            } else {
                print("Impossible de lire les données du payload")
                return nil
            }
        } catch {
            print("Erreur lors de la conversion JSON : \(error)")
            return nil
        }
    }
}
