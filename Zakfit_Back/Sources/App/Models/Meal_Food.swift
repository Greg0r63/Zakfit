//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 20/12/2024.
//

import Vapor
import Fluent

final class Meal_Food: Model, Content, @unchecked Sendable {
    static let schema: String = "meal_food"
    
    @ID(custom: "id_meal_food")
    var id: UUID?
    
    @Field(key: "id_meals")
    var id_meals: UUID
    
    @Field(key: "id_foods")
    var id_foods: UUID
    
    @Field(key: "quantity")
    var quantity: Double
    
    init() {}
    
    init(id: UUID? = UUID(), id_meals: UUID, id_foods: UUID, quantity: Double) {
        self.id = id
        self.id_meals = id_meals
        self.id_foods = id_foods
        self.quantity = quantity
    }
}
