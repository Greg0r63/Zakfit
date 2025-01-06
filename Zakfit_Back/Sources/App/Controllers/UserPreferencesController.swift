//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Vapor
import Fluent
import FluentSQL

struct UserPreferencesController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let userPref = routes.grouped("userpref")
        userPref.get(use: self.index)
        
        let authGroupToken = userPref.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        authGroupToken.get("pref",use: self.getActivePreferenceForUser)
        authGroupToken.post(use: self.handleUpdateOrCreate)
        
        userPref.delete(":userID",use: self.delete)
    }
    
    @Sendable
    func index(req: Request) async throws -> [UserPreference] {
        try await UserPreference.query(on: req.db).all()
    }
    
    @Sendable
    func getActivePreferenceForUser(req: Request) async throws -> [AlimentaryPreference] {
        let token = try req.auth.require(TokenSession.self)
        let userID = token.userId
        
        if let sql = req.db as? SQLDatabase {
            let alimentaryPreferences = try await sql.raw("SELECT ap.* FROM alimentary_preferences ap JOIN user_preferences up ON ap.id_alimentary_preferences = up.id_alimentary_preferences WHERE up.id_users = \(bind: userID) AND up.active_user_preferences = true;").all(decodingFluent: AlimentaryPreference.self)
            return alimentaryPreferences
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    
    @Sendable
    func handleUpdateOrCreate(req: Request) async throws -> HTTPStatus {
        let token = try req.auth.require(TokenSession.self)
        let userID = token.userId
        
        let updateRequest = try req.content.decode(UpdatePreferenceRequest.self)
        
        // Recherche d'une préférence existante
        if let existingPreference = try await findExistingPreference(req: req, userID: userID, preferenceID: updateRequest.preferenceID)
        {
            // Mettre à jour la préférence si elle existe
            try await updateUserPreference(preference: existingPreference, isActive: updateRequest.isActive, on: req)
        } else {
            // Créer une nouvelle préférence si elle n'existe pas
            try await createUserPreference(req: req, userID: userID, updateRequest: updateRequest)
        }
        
        return .ok
    }
    
    private func findExistingPreference(req: Request, userID: UUID, preferenceID: UUID) async throws -> UserPreference? {
        return try await UserPreference.query(on: req.db)
            .filter(\.$userID == userID)
            .filter(\.$alimentaryPreferenceID == preferenceID)
            .first()
    }
    
    private func updateUserPreference(preference: UserPreference, isActive: Bool, on req: Request) async throws {
        preference.isActive = isActive
        try await preference.save(on: req.db)
    }
    
    private func createUserPreference(req: Request, userID: UUID ,updateRequest: UpdatePreferenceRequest) async throws {
        let newPreference = UserPreference(
            userID: userID,
            alimentaryPreferenceID: updateRequest.preferenceID,
            isActive: updateRequest.isActive
        )
        try await newPreference.save(on: req.db)
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let userPreference = try await UserPreference.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await userPreference.delete(on: req.db)
        return .noContent
    }
}
