//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 11/12/2024.
//

import Vapor

struct UpdatedUser: Content, @unchecked Sendable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var size: Double?
    var weight: Double?
}
