//
//  CoinsRoute.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation
import Alamofire
import Combine

extension GekkoService {
    enum CoinsRoute: Routable {
        private var pathComponent: String { "coins" }
        
        case list
        case markets
        case id(String)
        case chart(String)
    
        var path: String {
            switch self {
            case .list: return pathComponent.appendPathComponent("list")
            case .markets: return pathComponent.appendPathComponent("markets")
            case .id(let id): return pathComponent.appendPathComponent(id)
            case .chart(let id): return pathComponent.appendPathComponent(id).appendPathComponent("market_chart")
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .list: return nil
            case .markets:
                return [
                    URLQueryItem(name: "vs_currency", value: "usd")
                ]
            case .id:
                return [
                    URLQueryItem(name: "localization", value: "en"),
                    URLQueryItem(name: "tickers", value: "false"),
                    URLQueryItem(name: "community_data", value: "false"),
                    URLQueryItem(name: "developer_data", value: "false")
                ]
            case .chart:
                return [
                    URLQueryItem(name: "vs_currency", value: "usd"),
                    URLQueryItem(name: "days", value: "1"),
                    URLQueryItem(name: "interval", value: "hourly")
                ]
            }
        }
        
        var httpMethod: String {
            switch self {
            case .list: return HTTPMethod.get.rawValue
            case .markets: return HTTPMethod.get.rawValue
            case .id: return HTTPMethod.get.rawValue
            case .chart: return HTTPMethod.get.rawValue
            }
        }
        
        static func getCoinList() -> Future<[Coin]?, Error> {
            Future() { promise in
                Activity.shared.isLoading = true
                Task {
                    do {
                        let coins: [Coin]? = try await GekkoService.networkLayer.request(route: Self.list)
                        promise(.success(coins))
                    } catch {
                        promise(.failure(error))
                    }
                    DispatchQueue.main.async {
                        Activity.shared.isLoading = false
                    }
                }
            }
        }
        
        static func getCoin(id: String) -> Future<CoinInfo?, Error> {
            Future() { promise in
                Activity.shared.isLoading = true
                Task {
                    do {
                        let coin: CoinInfo? = try await GekkoService.networkLayer.request(route: Self.id(id))
                        promise(.success(coin))
                    } catch {
                        promise(.failure(error))
                    }
                    
                    DispatchQueue.main.async {
                        Activity.shared.isLoading = false
                    }
                }
            }
        }
        
        static func getCoinChart(id: String) -> Future<MarketCharts?, Error> {
            Future() { promise in
                Task {
                    do {
                        let chart: MarketCharts? = try await GekkoService.networkLayer.request(route: Self.chart(id))
                        promise(.success(chart))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        
        static func getMarketList() -> Future<[Market]?, Error> {
            Future() { promise in
                Activity.shared.isLoading = true
                Task {
                    do {
                        let markets: [Market]? = try await GekkoService.networkLayer.request(route: Self.markets)
                        promise(.success(markets))
                    } catch {
                        promise(.failure(error))
                    }
                    DispatchQueue.main.async {
                        Activity.shared.isLoading = false
                    }
                }
            }
        }
    }
}

