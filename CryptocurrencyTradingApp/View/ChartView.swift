//
//  DetailView.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//


import SwiftUI

struct ChartView: View {
    @StateObject var viewModel: DetailViewModel
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinType) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackGround)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            chartDateLabel
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.secondary)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_ViewProvider: PreviewProvider {
    static var previews: some View {
        ChartView(coin: .btc)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in viewModel.highPriceList.indices {
                    let xPosition = geometry.size.width / CGFloat(viewModel.highPriceList.count) * CGFloat(index + 1)
                    
                    let yPosition = (1 - CGFloat((viewModel.highPriceList[index] - viewModel.minY) / viewModel.yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(viewModel.lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: viewModel.lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: viewModel.lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: viewModel.lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: viewModel.lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartBackGround: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(viewModel.maxY.description.toDecimal())
            Spacer()
            Text(viewModel.averageY.description.toDecimal())
            Spacer()
            Text(viewModel.minY.description.toDecimal())
        }
    }
    
    private var chartDateLabel: some View {
        HStack {
            Text(viewModel.startDate)
            Spacer()
            Text(viewModel.endDate)
        }
    }
}

