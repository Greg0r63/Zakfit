//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Vapor
import Fluent

final class AlimentaryPreference: Model, Content, @unchecked Sendable {
    static let schema: String = "alimentary_preferences"
    
    @ID(custom: "id_alimentary_preferences")
    var id: UUID?
    
    @Field(key: "name_alimentary_preferences")
    var name: String
    
    @Field(key: "description_alimentary_preferences")
    var description: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}
