//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 07/12/2024.
//

import Vapor
import FluentSQL

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: self.index)
        users.post(use: self.create)
        
        let authGroupBasic = users.grouped(User.authenticator(), User.guardMiddleware())
        authGroupBasic.post("login", use: self.login)
        
        let authGroupToken = users.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        authGroupToken.get("profile", use: self.getUserData)
        authGroupToken.put(use: self.update)
        
        users.group(":userID") { user in
            user.delete(use: self.delete)
        }
    }
    
    @Sendable
    func index(req: Request) async throws-> [UserDTO] {
        try await User.query(on: req.db).all().map { $0.toDTO()}
    }
    
    @Sendable
    func getUserData(req: Request) async throws -> UserDTO {
        let token = try req.auth.require(TokenSession.self)
        let userID = token.userId
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$id == userID)
            .first() else {
            throw Abort(.notFound, reason: "Utilisateur non-trouvé")
        }
        return user.toDTO()
    }
    
    @Sendable
    func create(req: Request) async throws -> UserDTO {
        
        // Cette ligne indique à Vapor que les données fournis dans le corps de la requête seront décodés dans une instance User
        let user = try req.content.decode(User.self)
        
        // Vérifie si l'email fourni existe déjà dans la base de donnée
        let existingUser = try await User.query(on: req.db)
            .filter(\.$email == user.email)
            .first()
        
        // Si Vapor ne trouve pas d'utilisateur existant déjà avec le même email que celui fournis dans le corps de la requête (nil), il va alors continuer l'éxécution du code
        guard existingUser == nil else {
            throw Abort(.conflict, reason: "Un utilisateur avec cet email existe déjà")
        }
        
        // Ici on crypte le mot de passe fournis dans le corps de la requête avec Bcrypt
        user.password = try Bcrypt.hash(user.password)
        
        // On sauvegarde les données fournis, avec le mot de passe crypté au préalable, dans la base de données
        try await user.save(on: req.db)
        
        // On utilise la fonction toDTO pour que le mot de passe fournis dans le corps ne soit pas retourné dans la réponse
        return user.toDTO()
    }
    
    @Sendable
    func update(req: Request) async throws -> UserDTO {
        let token = try req.auth.require(TokenSession.self)
        let userID = token.userId
        
        let updatedUser = try req.content.decode(UpdatedUser.self)
        
        guard let user = try await User.find(userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        if let updatedFirstName = updatedUser.firstName {
            user.firstName = updatedFirstName
        }
        if let updatedLastName = updatedUser.lastName {
            user.lastName = updatedLastName
        }
        if let updatedEmail = updatedUser.email {
            let existingUser = try await User.query(on: req.db)
                .filter(\.$email == updatedEmail)
                .first()
            guard existingUser == nil else {
                throw Abort(.conflict, reason: "Email déjà utilisé")
            }
            user.email = updatedEmail
        }
        if let updatedPassword = updatedUser.password {
            user.password = try Bcrypt.hash(updatedPassword)
        }
        if let updatedSize = updatedUser.size {
            user.size = updatedSize
        }
        if let updatedWeight = updatedUser.weight {
            user.weight = updatedWeight
        }
        
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func login(req: Request) async throws -> [String: String] {
        // On récupère les infos de connexion fournis par l'utilisateur
        guard let user = try? req.auth.require(User.self) else {
            return ["error" : "Email ou mot de passe invalide"]
        }
        // On crée le payload à partir de notre modèle et des informations de l'utilisateur
        let payload = try TokenSession(with: user)
        // On crée le token
        let token = try await req.jwt.sign(payload)
        // On le retourne à l'utilisateur
        return ["token": token]
    }
}
