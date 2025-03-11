//
//  Product.swift
//  OnlineStore-2nd-Challenge
//
//  Created by Александр Семёнов on 12.03.2025.
//

struct MyProduct: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}
