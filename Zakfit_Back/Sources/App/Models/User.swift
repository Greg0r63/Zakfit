//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 07/12/2024.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema: String = "users"
    
    @ID(custom: "id_users")
    var id: UUID?
    
    @Field(key: "first_name_users")
    var firstName: String
    
    @Field(key: "last_name_users")
    var lastName: String
    
    @Field(key: "email_users")
    var email: String
    
    @Field(key: "password_users")
    var password: String
    
    @Field(key: "size_users")
    var size: Double?
    
    @Field(key: "weight_users")
    var weight: Double?
    
    @Timestamp(key: "created_at_users", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at_users", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String, email: String, password: String, size: Double, weight: Double, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.size = size
        self.weight = weight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> UserDTO {
        UserDTO(id: self.id, firstName: self.firstName, lastName: self.lastName, email: self.email, size: self.size, weight: self.weight, createdAt: self.createdAt, updatedAt: self.updatedAt)
    }
}

extension User : ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
