//
//  MarketViewModel.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 11.07.2022.
//

import Foundation
import Combine

class MarketViewModel: ObservableObject {
    @Published var marketList: [Market] = []
    @Published var selectedCoinInfo: CoinInfo?
    @Published var coinChart: MarketCharts?
    
    @Published var isCoinInfoPresented = false
    
    @Published var marketSearchedText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        _selectedCoinInfo.projectedValue.compactMap({$0})
            .sink { [weak self] coinInfo in
                self?.isCoinInfoPresented = true
            }.store(in: &cancellables)
        
        _coinChart.projectedValue.compactMap({$0})
            .sink { charts in
                print(charts)
            }.store(in: &cancellables)
    }
    
    func fetchMarketList() {
        GekkoService.CoinsRoute.getMarketList()
            .replaceError(with: [])
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.marketList, on: self)
            .store(in: &cancellables)
    }
    
    func fetchCoinInfo(id: String) {
        GekkoService.CoinsRoute.getCoin(id: id)
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .assign(to: \.selectedCoinInfo, on: self)
            .store(in: &cancellables)
    }
    
    func fetchChart(id: String) {
        GekkoService.CoinsRoute.getCoinChart(id: id)
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .assign(to: \.coinChart, on: self)
            .store(in: &cancellables)
    }
}

extension MarketViewModel {
    func clearSelectedCoin() {
        selectedCoinInfo = nil
    }
}
