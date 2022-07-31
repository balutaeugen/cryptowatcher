//
//  NetworkLayerApp.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import SwiftUI

@main
struct NetworkLayerApp: App {
    @ObservedObject var activity = Activity.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    MarketView()
                }
                if activity.isLoading {
                    ActivityIndicator()
                }
            }
        }
    }
}
