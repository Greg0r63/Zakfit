//
//  Untitled.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 24/12/2024.
//

import Vapor

struct MealTypeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mealTypes = routes.grouped("mealTypes")
        mealTypes.get(use: self.index)
        mealTypes.post(use: self.create)
        
        mealTypes.group(":mealTypeID") { mealType in
            mealType.put(use: self.update)
            mealType.delete(use: self.delete)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [MealType] {
        try await MealType.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> MealType {
        let mealType = try req.content.decode(MealType.self)
        try await mealType.create(on: req.db)
        return mealType
    }
    
    @Sendable
    func update(req: Request) async throws -> MealType {
        guard let mealTypeIdString = req.parameters.get("mealTypeId"), let mealTypeID = UUID(uuidString: mealTypeIdString) else {
            throw Abort(.badRequest, reason: "Bad ID for meal type")
        }
        
        let updatedMealType = try req.content.decode(MealType.self)
        
        guard let mealType = try await MealType.find(mealTypeID, on: req.db) else {
            throw Abort(.badRequest, reason: "Meal type not found")
        }
        
        mealType.name = updatedMealType.name
        
        try await mealType.save(on: req.db)
        return mealType
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let mealType = try await Food.find(req.parameters.get("mealTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await mealType.delete(on: req.db)
        
        return .noContent
    }
}
