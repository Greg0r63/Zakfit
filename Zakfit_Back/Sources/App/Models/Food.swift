//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 20/12/2024.
//

import Vapor
import Fluent

final class Food: Model, Content, @unchecked Sendable {
    static let schema: String = "foods"
    
    @ID(custom: "id_foods")
    var id: UUID?
    
    @Field(key: "name_foods")
    var name: String
    
    @Field(key: "calories_foods")
    var calories: Double
    
    @Field(key: "proteins_foods")
    var proteins: Double
    
    @Field(key: "carbohydrates_foods")
    var carbohydrates: Double
    
    @Field(key: "lipids_foods")
    var lipids: Double
    
    @Field(key: "id_food_types")
    var foodTypeID: UUID
    
    init() {}
    
    init(id: UUID? = UUID(), name: String, calories: Double, proteins: Double, carbohydrates: Double, lipids: Double, foodTypeID: UUID) {
        self.id = id
        self.name = name
        self.calories = calories
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.lipids = lipids
        self.foodTypeID = foodTypeID
    }
}
