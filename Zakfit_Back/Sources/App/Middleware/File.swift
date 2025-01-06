//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 09/12/2024.
//

import Vapor

struct ErrorMiddleware: AsyncMiddleware {    
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            return try await next.respond(to: request)
        } catch let error as AbortError {
            let response = Response(status: error.status)
            try response.content.encode(["error": error.reason], as: .json)
            return response
        } catch {
            let response = Response(status: .internalServerError)
            try response.content.encode(["error": "Une erreur inconnue est survenue."], as: .json)
            return response
        }
    }
}
