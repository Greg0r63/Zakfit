//
//  UpdatedUser.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 10/12/2024.
//

import Foundation

/**
 Documentation de la structure UpdatedUser
 
 Cette structure représente un utilisateur qui a modifié ses informations et conforme au protocol Codable pour pouvoir l'encoder en JSON
 */

struct UpdatedUser: Encodable {
    /// Prénom modifié de l'utilisateur optionnel
    var firstName: String?
    /// Nom modifié de l'utilisateur optionnel
    var lastName: String?
    /// Email modifié de l'utilisateur optionnel
    var email: String?
    /// Mot de passe modifié de l'utilisateur optionnel
    var password: String?
    /// Taille modifié de l'utilisateur optionnelle
    var size: Double?
    /// Poids modifié de l'utilisateur optionnel
    var weight: Double?
}
