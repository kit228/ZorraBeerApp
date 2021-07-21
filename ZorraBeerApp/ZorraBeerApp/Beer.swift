//
//  Beer.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 19.07.2021.
//

import Foundation

class Beer {
    let name: String
    let description: String
    let imageUrl: String?
    let ingredients: String
    let foodPairing: String
    
    init(name: String, description: String, imageUrl: String?, ingredients: String, foodPairing: String) {
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.ingredients = ingredients
        self.foodPairing = foodPairing
    }
}
