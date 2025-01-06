//
//  JWTToken.swift
//  ZakFit_Front
//
//  Created by Apprenant 176 on 08/12/2024.
//

import Foundation

struct JWToken: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}
