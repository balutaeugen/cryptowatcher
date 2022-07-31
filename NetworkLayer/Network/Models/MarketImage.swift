//
//  MarketImage.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 14.07.2022.
//

import Foundation

//"image": {
//    "thumb": "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png?1547033579",
//    "small": "https://assets.coingecko.com/coins/images/1/small/bitcoin.png?1547033579",
//    "large": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
//}

struct MarketImage: Decodable {
    var thumb: URL
    var small: URL
    var large: URL
}
