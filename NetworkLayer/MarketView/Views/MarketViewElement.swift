//
//  MarketViewElement.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 14.07.2022.
//

import SwiftUI
import Kingfisher

struct MarketViewElement: View {
    @State var market: Market
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("cell_color_primary"))
            
            HStack(spacing: 12) {
                KFImage(market.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(market.symbol.uppercased())
                        .foregroundColor(Color("cell_text_primary"))
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(market.name)
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(Color("cell_text_primary").opacity(0.3))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(market.current_price)
                        .font(.headline)
                    Text(market.market_cap)
                        .font(.caption2)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
        }
    }
}
