//
//  File.swift
//  Zakfit_Back
//
//  Created by Apprenant 176 on 17/12/2024.
//

import Vapor

struct UpdatePreferenceRequest: Content {
    let preferenceID: UUID
    let isActive: Bool
}


