//
//  MiniChartView.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/30.
//

import SwiftUI

struct MiniChart: View {
    @ObservedObject var viewModel: PopularCoinViewModel

    var body: some View {
        
        VStack {
            chartView
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.secondary)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.5)) {
                    
                }
            }
        }
    }
    
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
            .trim(from: 0, to: 1)
            .stroke(viewModel.lineColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            .shadow(color: viewModel.lineColor, radius: 10, x: 0.0, y: 10)
        }
    }
}
