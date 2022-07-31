//
//  ContentView.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import SwiftUI
import Kingfisher

struct MarketView: View {
    @StateObject var viewModel = MarketViewModel()
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.marketList) { market in
                        ZStack {
//                            MarketViewElement(market: market)
                            
                            NavigationLink{
                                CoinInfoView(marketId: market.id)
                                    .environmentObject(viewModel)
                            } label: {
                                MarketViewElement(market: market)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .searchable(text: $viewModel.marketSearchedText)
        .navigationTitle("CryptoWatcher")
        .onAppear {
            viewModel.fetchMarketList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}
