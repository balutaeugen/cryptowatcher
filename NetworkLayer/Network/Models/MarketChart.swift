//
//  MarketChart.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 12.07.2022.
//

import Foundation

struct MarketCharts: Decodable {
    var prices: [(id: String, timestamp: TimeInterval, value: Double)]
    var market_caps: [(id: String, timestamp: TimeInterval, value: Double)]
    var total_volumes: [(id: String, timestamp: TimeInterval, value: Double)]
    
    enum CodingKeys: CodingKey {
        case prices
        case market_caps
        case total_volumes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pricesArray = try container.decode([[Double]].self, forKey: .prices)
        prices = pricesArray.map({(UUID().uuidString, $0[0] / 1000.0, $0[1])})
        
        let capsArray = try container.decode([[Double]].self, forKey: .market_caps)
        market_caps = capsArray.map({(UUID().uuidString, $0[0] / 1000.0, $0[1])})
        
        let volumesArray = try container.decode([[Double]].self, forKey: .total_volumes)
        total_volumes = volumesArray.map({(UUID().uuidString, $0[0] / 1000.0, $0[1])})
    }
}
