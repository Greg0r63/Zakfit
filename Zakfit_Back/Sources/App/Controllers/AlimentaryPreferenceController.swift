//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Vapor

struct AlimentaryPreferenceController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let aliPreferences = routes.grouped("alipreferences")
        aliPreferences.get(use: self.index)
        aliPreferences.post(use: self.create)
        
        aliPreferences.group("aliPreferenceID") { aliPreference in
            aliPreference.put(use: self.update)
            aliPreference.delete(use: self.delete)
        }
        
    }
    
    @Sendable
    func index(req: Request) async throws -> [AlimentaryPreference] {
        try await AlimentaryPreference.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> AlimentaryPreference {
        let alimentaryPreference = try req.content.decode(AlimentaryPreference.self)
        try await alimentaryPreference.save(on: req.db)
        return alimentaryPreference
    }
    
    @Sendable
    func update(req: Request) async throws -> AlimentaryPreference {
        guard let alimentaryPreferenceIDString = req.parameters.get("aliPreferenceID"),
              let alimentaryPreferenceID = UUID(uuidString: alimentaryPreferenceIDString) else {
            throw Abort(.badRequest, reason: "Bad ID for alimentary preference")
        }
        
        let updatedAlimentaryPreference = try req.content.decode(AlimentaryPreference.self)
        
        guard let alimentaryPreference = try await AlimentaryPreference.find(alimentaryPreferenceID, on: req.db) else {
            throw Abort(.notFound, reason: "Alimentary preference not found")
        }
        
        alimentaryPreference.name = updatedAlimentaryPreference.name
        alimentaryPreference.description = updatedAlimentaryPreference.description
        
        try await alimentaryPreference.save(on: req.db)
        return alimentaryPreference
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let alimentaryPreference = try await AlimentaryPreference.find(req.parameters.get("aliPreferenceID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await alimentaryPreference.delete(on: req.db)
        return .noContent
    }
}
