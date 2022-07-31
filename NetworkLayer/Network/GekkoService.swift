//
//  GekkoService.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation

struct GekkoService {
    static let baseUrl = "https://api.coingecko.com/api/v3"
    
    static let networkLayer = NetworkLayer(baseUrl: baseUrl)
}
