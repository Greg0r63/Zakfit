//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 20/12/2024.
//

import Vapor
import Fluent

final class MealType: Model, Content, @unchecked Sendable {
    static let schema: String = "meal_types"
    
    @ID(custom: "id_meal_types")
    var id: UUID?
    
    @Field(key: "name_meal_types")
    var name: String
    
    init() {}
    
    init(id: UUID? = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
