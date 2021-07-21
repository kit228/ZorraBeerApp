//
//  BeerJsonResponseCodable.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 18.07.2021.
//

import Foundation

struct BeerJsonResponseStruct: Codable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String?
    let ingredients: IngredientsStruct
    let food_pairing: [String]
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case imageUrl = "image_url"
        case ingredients = "ingredients"
        case food_pairing = "food_pairing"
    }
}

struct IngredientsStruct: Codable {
    let malt: [MaltStruct] // солод
    let hops: [HopsStruct] // хмель
    
    private enum CodingKeys: String, CodingKey {
        case malt = "malt"
        case hops = "hops"
    }
}

struct MaltStruct: Codable {
    let name: String
    let amount: AmountStruct // количество
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case amount = "amount"
    }
}

struct AmountStruct: Codable {
    let value: Double
    let unit: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case unit = "unit"
    }
}

struct HopsStruct: Codable {
    let name: String
    let amount: AmountStruct
    let add: String
    let attribute: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case amount = "amount"
        case add = "add"
        case attribute = "attribute"
    }
}
