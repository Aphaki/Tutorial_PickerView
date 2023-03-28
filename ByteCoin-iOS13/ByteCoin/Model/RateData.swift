//
//  RateData.swift
//  ByteCoin
//
//  Created by Sy Lee on 2023/03/22.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

// MARK: - RateData
struct RateData: Codable {
    let assetIDBase: String
    let rates: [Rate]

    enum CodingKeys: String, CodingKey {
        case assetIDBase = "asset_id_base"
        case rates
    }
}

// MARK: - Rate
struct Rate: Codable {
    let time, assetIDQuote: String
    let rate: Double
    var rateString: String {
        let value = String(format: "%.2f", rate)
        return value
    }

    enum CodingKeys: String, CodingKey {
        case time
        case assetIDQuote = "asset_id_quote"
        case rate
    }
}
