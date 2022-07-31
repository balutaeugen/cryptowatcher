//
//  CoinTopView.swift
//  NetworkLayer
//
//  Created by Eugen Baluta on 14.07.2022.
//

import SwiftUI
import Charts

internal typealias ChartElement = (id: String, timestamp: TimeInterval, value: Double)

struct CoinTopView: View {
    @State var coin: CoinInfo
    @State var charts: [ChartElement] = []
    @State var selectedElement: ChartElement?
    
    var chart: some View {
        Chart(charts, id: \.id) { element in
            LineMark(
                x: .value("Date", element.timestamp),
                y: .value("Value", element.value)
            )
            .foregroundStyle(chartColor())
            .interpolationMethod(.catmullRom)
            
            AreaMark(
                x: .value("Date", element.timestamp),
                y: .value("Value", element.value)
            )
            .foregroundStyle(areaGradient)
            .interpolationMethod(.catmullRom)
            
            if isPointable(element: element), let element = selectedElement {
                RuleMark(x: .value("Date", element.timestamp))
                    .foregroundStyle(Color.gray.opacity(0.3))
                
                PointMark(
                    x: .value("Date", element.timestamp),
                    y: .value("Value", element.value)
                )
                .foregroundStyle(chartColor())
                .annotation(position: annotationPosition(for: element)) {
                    Text(formatePrice(element.value as NSNumber))
                        .font(.system(size: 10, weight: .bold))
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .extended) {
                let value = $0.as(TimeInterval.self) ?? 0.0
                AxisValueLabel(centered: true) { Text(value.date.hourly) }
            }
        }
        .chartXScale(domain: timeIntervalRange())
        .chartYAxis {
            AxisMarks(position: .leading) {
                let value = $0.as(Double.self) ?? 0.0
                AxisGridLine(stroke: StrokeStyle(dash: [0, 2, 4]))
                AxisValueLabel {
                    Text(value.shortStringRepresentation)
                }
            }
        }
        .chartYScale(domain: valueRange())
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged { value in
                            updateSelectedValue(at: value.location,
                                               proxy: proxy,
                                               geometry: geometry)
                        }
                    )
                    .onTapGesture { location in
                        updateSelectedValue(at: location,
                                           proxy: proxy,
                                           geometry: geometry)
                    }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(formatePrice(coin.market_data.current_price.usd as NSNumber, digits: 2))
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
            }
            
            chart
                .frame(height: 200)
        }
    }
}

extension CoinTopView {
    private var areaGradient: Gradient {
        Gradient(stops: [
            Gradient.Stop(color: chartColor().opacity(0.3), location: 0),
            Gradient.Stop(color: .clear, location: 0.075),
        ])
    }
}

extension CoinTopView {
    internal func minChart() -> Double {
        charts.max(by: {$0.value > $1.value})?.value ?? 0.0
    }
    
    internal func maxChart() -> Double {
        charts.min(by: {$0.value > $1.value})?.value ?? 0.0
    }
    
    internal func valueRange() -> ClosedRange<Double> {
        return max(0, minChart() - minChart() * 0.03)...(maxChart() + maxChart() * 0.03)
    }
    
    internal func timeIntervalRange() -> ClosedRange<TimeInterval> {
        let min = charts.min(by: {$0.timestamp < $1.timestamp})?.timestamp ?? 0.0
        let max = charts.max(by: {$0.timestamp < $1.timestamp})?.timestamp ?? 0.0
        return min...max
    }
    
    internal func isPointable(element: ChartElement) -> Bool {
        element.timestamp == selectedElement?.timestamp
    }
    
    internal func updateSelectedValue(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let timestamp: TimeInterval = proxy.value(atX: xPosition) else {
            return
        }
        
        selectedElement = charts.min(by: {abs($0.timestamp - timestamp) < abs($1.timestamp - timestamp)})
    }
    
    internal func annotationPosition(for element: ChartElement) -> AnnotationPosition {
        if (charts.dropFirst(charts.count - 3).contains(where: {$0.timestamp == element.timestamp})) {
            return .topLeading
        }
        
        if (charts.dropLast(charts.count - 2).contains(where: {$0.timestamp == element.timestamp})) {
            return .topTrailing
        }
        
        return .top
    }
    
    internal func chartColor() -> Color {
        if coin.market_data.price_change_percentage_24h.isLess(than: 0) { return Color.red }
        return Color.green
    }
    
    internal func formatePrice(_ price: NSNumber, digits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = digits
        return numberFormatter.string(from: price)!
    }
}

extension Double {
    var shortStringRepresentation: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", "k", "M"]
        var interval = self
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval))\(units[i])"
    }
}

extension Date {
    var hourly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

extension TimeInterval {
    var date: Date {
        Date(timeIntervalSince1970: self)
    }
}
