//
//  Coin.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation
// {
//     "id": "bitcoin",
//     "symbol": "btc",
//     "name": "Bitcoin"
// }

struct Coin: Identifiable, Decodable {
    var id: String
    var symbol: String
    var name: String
}
