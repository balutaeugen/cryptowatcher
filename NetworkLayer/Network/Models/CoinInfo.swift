//
//  CoinInfo.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation

struct CoinInfo: Identifiable, Decodable {
    var id: String
    var symbol: String
    var name: String
    var image: MarketImage
    var hashing_algorithm: String?
    var description: Dictionary<String, String>
    var genesis_date: String?
    var market_cap_rank: Int
    var last_updated: String
    var market_data: MarketData
    
    // var tickers: [Ticker]
}

struct MarketData: Decodable {
    var price_change_percentage_24h: Double
    var current_price: LocalizedPrice
}

struct LocalizedPrice: Decodable {
    var usd: Double
}
