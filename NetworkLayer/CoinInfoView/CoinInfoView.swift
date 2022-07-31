//
//  CoinInfoView.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 12.07.2022.
//

import SwiftUI
import Charts
import Kingfisher

struct CoinInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: MarketViewModel
    @State var marketId: String
    
    var body: some View {
        ZStack {
            ScrollView {
                if let coin = viewModel.selectedCoinInfo {
                    CoinTopView(coin: coin, charts: viewModel.coinChart?.prices ?? [])
                        .padding(.horizontal, 16)
                }
                
                RichText(html: viewModel.selectedCoinInfo?.description["en"] ?? "")
                    .lineHeight(170)
                    .colorScheme(ColorScheme.auto)
                    .imageRadius(12)
                    .fontType(FontType.system)
                    .foregroundColor(light: Color.black, dark: Color.white)
                    .linkColor(light: Color.blue, dark: Color.blue)
                    .colorPreference(forceColor: .onlyLinks)
                    .customCSS("")
                    .placeholder {
                        Text("loading")
                    }

            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let coin = viewModel.selectedCoinInfo {
                    HStack(spacing: 8) {
                        KFImage(coin.image.small)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                        Text(coin.symbol.uppercased())
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("#\(coin.market_cap_rank)")
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray)
                                    .padding(.horizontal, -4)
                                    .padding(.vertical, -2)
                            )
                            .padding(.horizontal, 4)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCoinInfo(id: marketId)
            viewModel.fetchChart(id: marketId)
        }
        .onDisappear {
            viewModel.clearSelectedCoin()
        }
    }
}

struct CoinInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinInfoView(marketId: "bitcoin")
    }
}
