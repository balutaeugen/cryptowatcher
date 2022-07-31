//
//  Ticker.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 12.07.2022.
//

import Foundation
//{
//    "base": "BTC",
//    "target": "USDT",
//    "market": {
//        "name": "Binance",
//        "identifier": "binance",
//        "has_trading_incentive": false
//    },
//    "last": 19845.16,
//    "volume": 135363.60414731142,
//    "converted_last": {
//        "btc": 1.000319,
//        "eth": 18.389271,
//        "usd": 19855.75
//    },
//    "converted_volume": {
//        "btc": 135407,
//        "eth": 2489238,
//        "usd": 2687745675
//    },
//    "trust_score": "green",
//    "bid_ask_spread_percentage": 0.013879,
//    "timestamp": "2022-07-12T07:02:32+00:00",
//    "last_traded_at": "2022-07-12T07:02:32+00:00",
//    "last_fetch_at": "2022-07-12T07:02:32+00:00",
//    "is_anomaly": false,
//    "is_stale": false,
//    "trade_url": "https://www.binance.com/en/trade/BTC_USDT?ref=37754157",
//    "token_info_url": null,
//    "coin_id": "bitcoin",
//    "target_coin_id": "tether"
//}

struct Ticker: Identifiable, Decodable {
    var id: String
    var base: String
    var target: String
    var last: Double
    var volume: Double
    var trust_score: String
    var timestamp: Date
    var is_anomaly: Bool
    var is_stale: Bool
    
    enum CodingKeys: CodingKey {
        case base
        case target
        case last
        case volume
        case trust_score
        case timestamp
        case is_anomaly
        case is_stale
        case coin_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(String.self, forKey: .base)
        self.target = try container.decode(String.self, forKey: .target)
        self.last = try container.decode(Double.self, forKey: .last)
        self.volume = try container.decode(Double.self, forKey: .volume)
        self.trust_score = try container.decode(String.self, forKey: .trust_score)
        self.timestamp = (try container.decode(String.self, forKey: .timestamp)).toDate()
        self.is_anomaly = try container.decode(Bool.self, forKey: .is_anomaly)
        self.is_stale = try container.decode(Bool.self, forKey: .is_stale)
        self.id = try container.decode(String.self, forKey: .coin_id)
    }
}

internal extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZ"
        return dateFormatter.date(from: self) ?? Date()
    }
}
