//
//  UserPreference.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 18/12/2024.
//

import Foundation

struct UserPreference: Decodable, Identifiable {
    var id: UUID
    var name: String
    var description: String
}
