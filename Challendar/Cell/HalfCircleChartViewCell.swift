//
//  HalfCircleChartViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SwiftUI
import SnapKit

// SwiftUI를 UIHostingController 이용해 만든 Cell
class HalfCircleChartViewCell: UICollectionViewCell {
    static var identifier = "HalfCircleChartViewCell"
    private var halfCircleHostingController: UIHostingController<ChallengeChartView>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondary850
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 220),
        ])
        setupChartView()
    }
    
    private func setupChartView() {
        let chartView = ChallengeChartView(todoProgress: [])
        halfCircleHostingController = UIHostingController(rootView: chartView)
        
        guard let halfCircleHostingController = halfCircleHostingController else { return }
        
        halfCircleHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        halfCircleHostingController.view.backgroundColor = .clear
        contentView.addSubview(halfCircleHostingController.view)
        
        halfCircleHostingController.view.snp.makeConstraints{
            $0.edges.equalTo(contentView)
        }
    }
    
    func configure(with todoProgress: [Todo]) {
        let chartView = ChallengeChartView(todoProgress: todoProgress)
        halfCircleHostingController?.rootView = chartView
    }
    
    func configureDetail(with todo: Todo){
        let chartView = ChallengeChartView(percentage: todo.getPercentageToToday())
        halfCircleHostingController?.rootView = chartView
    }

}

// 챌린지 반원 차트 뷰
struct ChallengeChartView: View {
    var todoProgress: [Todo]?
    var percentage: Double?
    
    private var progress: Double {
        if let todoProgress = todoProgress {
            let total = Double(todoProgress.count)
            let completed = todoProgress.filter { $0.percentage == 1.0 }.count
            return total == 0 ? 0 : Double(completed) / total
        } else if let percentage = percentage {
            return percentage
        } else {
            return 0
        }
    }
    
    var trackLineWidth: CGFloat = 20
    var progressLineWidth: CGFloat = 30
    var trackColor: Color = Color.gray
    var progressColor: [Color] = [Color.challendarGreen200]
    var chartSize: CGSize = CGSize(width: 220, height: 220) // 기본 크기 설정
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(chartSize.width, chartSize.height) / 2
            let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
            
            ZStack {
                // Track (background circle)
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
                }
                .stroke(trackColor, style: StrokeStyle(lineWidth: trackLineWidth, lineCap: .round))
                
                // Progress (foreground circle)
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees:180), endAngle: Angle(degrees:180 + (progress * 180)), clockwise: false)
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: progressColor),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: progressLineWidth, lineCap: .round)
                )
                
                Text("\(Int(progress * 100))%")
                    .font(Font(UIFont.pretendardMedium(size: 46.7)))
                    .foregroundColor(.white)
                    .position(center)
            }
            .frame(width: chartSize.width, height: chartSize.height)
            .background(Color(.secondary850))
        }
        .frame(width: 220, height: 110)
        .padding(0)
    }
}




