//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 07/12/2024.
//

import Vapor

struct UserDTO: Content {
    let id: UUID?
    let firstName: String
    let lastName: String
    let email: String
    let size: Double?
    let weight: Double?
    let createdAt: Date?
    let updatedAt: Date?
    
    func toModel() -> User {
        return User(id: self.id, firstName: self.firstName, lastName: self.lastName, email: self.email, password: "default", size: self.size!, weight: self.weight!, createdAt: self.createdAt, updatedAt: self.updatedAt)
    }
}
