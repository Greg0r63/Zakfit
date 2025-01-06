//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 08/12/2024.
//

import Vapor
import JWTKit

struct TokenSession: Content, Authenticatable, JWTPayload {
    var expirationTime: TimeInterval = 120 * 60 * 60
    
    // Token Data
    var expiration: ExpirationClaim
    var userId: UUID
    
    init(with user: User) throws {
        self.userId = try user.requireID()
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(expirationTime))
    }
    
    func verify(using algorithm: some JWTAlgorithm) throws {
        try expiration.verifyNotExpired()
    }
}
