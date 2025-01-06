//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 24/12/2024.
//

import Vapor

struct FoodController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let foods = routes.grouped("foods")
        foods.get(use: self.index)
        foods.post(use: self.create)
        
        foods.group(":foodID") { food in
            food.put(use: self.update)
            food.delete(use: self.delete)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [Food] {
        try await Food.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> Food {
        let food = try req.content.decode(Food.self)
        
        try await food.save(on: req.db)
        
        return food
    }
    
    @Sendable
    func update(req: Request) async throws -> Food {
        guard let foodIDString = req.parameters.get("foodID"),
              let foodID = UUID(uuidString: foodIDString) else {
            throw Abort(.badRequest, reason: "Bad ID for food")
        }
        
        let updatedFood = try req.content.decode(Food.self)
        
        guard let food = try await Food.find(foodID, on: req.db) else {
            throw Abort(.notFound, reason: "Food not found")
        }
        
        food.name = updatedFood.name
        food.calories = updatedFood.calories
        food.proteins = updatedFood.proteins
        food.carbohydrates = updatedFood.carbohydrates
        food.lipids = updatedFood.lipids
        food.foodTypeID = updatedFood.foodTypeID
        
        try await food.save(on: req.db)
        
        return food
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let food = try await Food.find(req.parameters.get("foodID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await food.delete(on: req.db)
        
        return .noContent
    }
}
