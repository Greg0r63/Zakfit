//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 20/12/2024.
//

import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    static let schema: String = "meals"
    
    @ID(custom: "id_meals")
    var id: UUID?
    
    @Field(key: "date_meals")
    var date: Date?
    
    @Field(key: "calories_meals")
    var calories: Double
    
    @Field(key: "proteins_meals")
    var proteins: Double
    
    @Field(key: "carbohydrates_meals")
    var carbohydrates: Double
    
    @Field(key: "lipids_meals")
    var lipids: Double
    
    @Field(key: "id_meal_types")
    var mealTypeID: UUID
    
    @Field(key: "id_users")
    var userID: UUID
    
    init() {}
    
    init(id: UUID? = UUID(), date: Date? = nil, calories: Double, proteins: Double, carbohydrates: Double, lipids: Double, mealTypeID: UUID) {
        self.id = id
        self.date = date
        self.calories = calories
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.lipids = lipids
        self.mealTypeID = mealTypeID
    }
    
    
}
