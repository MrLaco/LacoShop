//
//  Advert.swift
//  LacoShop
//
//  Created by Данил Терлецкий on 24.08.2023.
//

import Foundation

struct AdvertResponse: Codable {
    let advertisements: [Advert]
}

struct Advert: Codable {

    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case location
        case imageUrl = "image_url"
        case createdDate = "created_date"
    }
}
