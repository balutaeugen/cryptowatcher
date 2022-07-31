//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import UIKit
import Foundation
import Alamofire

class NetworkLayer {
    private var session: Alamofire.Session
    private var baseUrl: String
    
    init(baseUrl: String) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        
        self.session = Session(configuration: configuration)
        self.baseUrl = baseUrl
    }
    
    
    /// Network Layer basic request
    /// - Parameter route: Route containing request information
    /// - Returns: Generic type return
    func request<D: Decodable>(route: Routable) async throws -> D? {
        guard var baseURL = URL(string: baseUrl)
        else { throw NetworkLayerError.invalidURL }
        
        baseURL.appendPathComponent(route.path)
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        else { throw NetworkLayerError.invalidURL }
        
        components.queryItems = route.queryItems
        
        guard let endpointUrl = components.url
        else { throw NetworkLayerError.invalidURL }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpointUrl, method: HTTPMethod(rawValue: route.httpMethod))
                .validate()
                .responseDecodable(of: D.self) { dataResponse in
                    switch dataResponse.result {
                    case .success(let decodable):
                        continuation.resume(returning: decodable)
                    case .failure(let error):
                        #if DEBUG
                        print(dataResponse.response?.headers.value(for: "Retry-After") ?? "")
                        print(error)
                        #endif
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    /// Network Layer basic request using body parameters
    /// - Parameters:
    ///   - route: Route containing request information
    ///   - body: Parameters for the request
    /// - Returns: Generic type return
    func request<D: Decodable, E: Encodable>(route: Routable, body: E) async throws -> D? {
        guard var baseURL = URL(string: baseUrl)
        else { throw NetworkLayerError.invalidURL }
        
        baseURL.appendPathComponent(route.path)
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        else { throw NetworkLayerError.invalidURL }
        
        components.queryItems = route.queryItems
        
        guard let endpointUrl = components.url
        else { throw NetworkLayerError.invalidURL }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpointUrl, method: HTTPMethod(rawValue: route.httpMethod), parameters: body)
                .validate()
                .responseDecodable(of: D.self) { dataResponse in
                    switch dataResponse.result {
                    case .success(let decodable):
                        continuation.resume(returning: decodable)
                    case .failure(let error):
                        #if DEBUG
                        print(dataResponse.response?.headers.value(for: "Retry-After") ?? "")
                        print(error)
                        #endif
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

enum NetworkLayerError: Error {
    case invalidURL
}

protocol Routable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: String { get }
}
