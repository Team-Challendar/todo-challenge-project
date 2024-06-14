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
    var textLabel = UILabel()
    
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
            contentView.heightAnchor.constraint(equalToConstant: 206),
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
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(110)
        }
        textLabel.font = .pretendardRegular(size: 14)
        textLabel.textColor = .secondary600
        textLabel.text = "시작한 날에서 오늘까지의 달성률이에요"
        contentView.addSubview(textLabel)
        contentView.bringSubviewToFront(textLabel)
        textLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-26.5)
            $0.centerX.equalToSuperview()
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
    var chartSize: CGSize = CGSize(width: 220, height: 110) // 기본 크기 설정
    
    var body: some View {
        let radius = (chartSize.height*2 - max(trackLineWidth, progressLineWidth)) / 2 // 반지름 조정
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        
        ZStack {
            // Track (background circle)
            Path { path in
                path.addArc(center: center, radius: radius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
            }
            .stroke(trackColor, style: StrokeStyle(lineWidth: trackLineWidth, lineCap: .round))
            
            // Progress (foreground circle)
            Path { path in
                path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 180 + (progress * 180)), clockwise: false)
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
                           .font(Font(UIFont.pretendardBold(size: 28)))
                           .foregroundColor(.white)
                           .position(x: chartSize.width / 2, y: chartSize.height / 2 - 6)
        }
        .frame(width: chartSize.width, height: 110)
        .background(Color(.secondary850))
    }
}





