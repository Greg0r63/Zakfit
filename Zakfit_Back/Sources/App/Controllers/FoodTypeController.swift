//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 24/12/2024.
//

import Vapor

struct FoodTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let foodTypes = routes.grouped("foodTypes")
        foodTypes.get(use: self.index)
        foodTypes.post(use: self.create)
        
        foodTypes.group(":foodTypeID") { foodtype in
            foodtype.put(use: self.update)
            foodtype.delete(use: self.delete)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [FoodType] {
        try await FoodType.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> FoodType {
        let foodType = try req.content.decode(FoodType.self)
        
        try await foodType.save(on: req.db)
        
        return foodType
    }
    
    @Sendable
    func update(req: Request) async throws -> FoodType {
        guard let foodTypeIDString = req.parameters.get("foodTypeID"),
              let foodTypeID = UUID(uuidString: foodTypeIDString) else {
            throw Abort(.badRequest, reason: "Bad ID for food type")
        }
        
        let updatedFoodType = try req.content.decode(FoodType.self)
        
        guard let foodType = try await FoodType.find(foodTypeID, on: req.db) else {
            throw Abort(.notFound, reason: "Food type not found")
        }
        
        foodType.name = updatedFoodType.name
        
        try await foodType.save(on: req.db)
        
        return foodType
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let foodType = try await FoodType.find(req.parameters.get("foodTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await foodType.delete(on: req.db)
        
        return .noContent
    }
}
