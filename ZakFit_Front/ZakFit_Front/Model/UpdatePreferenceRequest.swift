//
//  UpdataPreferenceRequest.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 18/12/2024.
//

import Foundation

struct UpdatePreferenceRequest: Codable {
    var preferenceID: UUID
    var isActive: Bool
}
