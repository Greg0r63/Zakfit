//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 24/12/2024.
//

import Vapor

struct MealController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        
    }
    
    @Sendable
    func index(req: Request) async throws -> [Meal] {
        try await Meal.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> Meal {
        let meal = try req.content.decode(Meal.self)
        
        try await meal.save(on: req.db)
        
        return meal
    }
    
    @Sendable
    func update(req: Request) async throws -> Meal {
        guard let mealIDString = req.parameters.get("mealID"), let mealID = UUID(uuidString: mealIDString) else {
            throw Abort(.badRequest, reason: "Bad ID for meal")
        }
        
        let updatedMeal = try req.content.decode(Meal.self)
        
        guard let meal = try await Meal.find(mealID, on: req.db) else {
            throw Abort(.badRequest, reason: "Meal not found")
        }
        
        meal.calories = updatedMeal.calories
        meal.proteins = updatedMeal.proteins
        meal.carbohydrates = updatedMeal.carbohydrates
        meal.lipids = updatedMeal.lipids
            
        try await meal.save(on: req.db)
        
        return meal
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let meal = try await Meal.find(req.parameters.get("mealID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await meal.delete(on: req.db)
        
        return .noContent
    }
}
