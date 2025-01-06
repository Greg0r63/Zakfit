//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Vapor
import Fluent

final class UserPreference: Model, Content, @unchecked Sendable {
    static let schema: String = "user_preferences"
    
    @ID(custom: "id_user_preferences")
    var id: UUID?
    
    @Field(key: "id_users")
    var userID: UUID
    
    @Field(key: "id_alimentary_preferences")
    var alimentaryPreferenceID: UUID
    
    @Field(key: "active_user_preferences")
    var isActive: Bool
    
    init() { }
    
    init(id: UUID? = nil, userID: UUID, alimentaryPreferenceID: UUID, isActive: Bool = false) {
        self.id = id
        self.userID = userID
        self.alimentaryPreferenceID = alimentaryPreferenceID
        self.isActive = isActive
    }
    
}
