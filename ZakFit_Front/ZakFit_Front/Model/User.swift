//
//  User.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 07/12/2024.
//

import Foundation

/**
 Documentation de la structure de donnée User
 
 Cette structure représente un utilisateur qui conforme aux protocols Codable et Identifiable pour pouvoir l'encoder en format JSON
 */

struct User: Codable, Identifiable {
    /// ID de l'utilisateur
    var id: UUID = UUID()
    /// Prénom de l'utilisateur
    var firstName: String
    /// Nom de l'utilisateur
    var lastName: String
    /// Email de l'utilisateur
    var email: String
    /// Taille de l'utilisateur optionnelle
    var size: Double?
    /// Poid de l'utilisateur optionnel
    var weight: Double?
    /// Date à laquelle l'utilisateur à été crée
    var createdAt: String?
    /// Date à laquelle l'utilisateur à été mis à jour 
    var updatedAt: String?
}


