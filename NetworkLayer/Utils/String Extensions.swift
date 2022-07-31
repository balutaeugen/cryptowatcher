//
//  String Extensions.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation

extension String {
    func appendPathComponent(_ component: String) -> String {
        return self + "/" + component.replacingOccurrences(of: "/", with: "")
    }
}
