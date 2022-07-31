//
//  Market.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation
// {
//     "id": "gala",
//     "symbol": "gala",
//     "name": "Gala",
//     "image": "https://assets.coingecko.com/coins/images/12493/large/GALA-COINGECKO.png?1600233435",
//     "current_price": 0.05146,
//     "market_cap": 387841108,
//     "market_cap_rank": 99,
//     "fully_diluted_valuation": 2571039336,
//     "total_volume": 116987775,
//     "high_24h": 0.054202,
//     "low_24h": 0.051063,
//     "price_change_24h": -0.002742528275083485,
//     "price_change_percentage_24h": -5.0598,
//     "market_cap_change_24h": -21038594.8177675,
//     "market_cap_change_percentage_24h": -5.14542,
//     "circulating_supply": 7542496572.319239,
//     "total_supply": 37795667237.2041,
//     "max_supply": 50000000000.0,
//     "ath": 0.824837,
//     "ath_change_percentage": -93.75989,
//     "ath_date": "2021-11-26T01:03:48.731Z",
//     "atl": 0.00013475,
//     "atl_change_percentage": 38097.37921,
//     "atl_date": "2020-12-28T08:46:48.367Z",
//     "roi": null,
//     "last_updated": "2022-07-11T08:33:53.047Z"
// }

struct Market: Identifiable, Decodable {
    var id: String
    var symbol: String
    var name: String
    var image: URL?
    var current_price: String = ""
    var market_cap: String = ""
    var price_change_percentage_24h: Double
    
    enum CodingKeys: CodingKey {
        case id
        case symbol
        case name
        case image
        case current_price
        case market_cap
        case price_change_percentage_24h
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(URL.self, forKey: .image)
        self.price_change_percentage_24h = try container.decode(Double.self, forKey: .price_change_percentage_24h)
        
        let price = try container.decode(Double.self, forKey: .current_price)
        let marketCap = try container.decode(Double.self, forKey: .market_cap)
        
        self.current_price = formatePrice(price as NSNumber)
        self.market_cap = formatePrice(marketCap as NSNumber)
    }
}

extension Market {
    internal func formatePrice(_ price: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 4
        return numberFormatter.string(from: price)!
    }
}
