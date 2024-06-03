//
//  ChallengeCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SwiftUI
import Charts
import SnapKit

// 파이 차트 뷰,
struct PieChartView: View {
    var dailyCompletionStatus: [Bool?]

    private func color(for status: String) -> Color {
        switch status {
        case "수행함":
            return .challendarGreen100
        case "수행 못함":
            return .clear
        default:
            return .clear
        }
    }

    var body: some View {
        
        let completedCount = dailyCompletionStatus.filter { $0 == true }.count
        let notCompletedCount = dailyCompletionStatus.count - completedCount
        
        let data = [
            (status: "수행함", count: completedCount),
            (status: "수행 못함", count: notCompletedCount)
        ]
        
        Chart {
            ForEach(data, id: \.status) { element in
                SectorMark(angle: .value("수행함", element.count))
                    .foregroundStyle(color(for: element.status))
            }
        }
        .padding(-10)
        .frame(width: 19, height: 19)
        .cornerRadius(5.5)
        .clipped()
    }
}

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    var checkButton: UIButton!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var stateLabel: UILabel!
    private var pieHostingController: UIHostingController<PieChartView>?
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
        contentView.backgroundColor = .challendarBlack80
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .pretendardMedium(size: 20)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .challendarGreen100
        dateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(dateLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .challendarBlack60
        stateLabel.font = .pretendardMedium(size: 12)
        contentView.addSubview(stateLabel)
        
        checkButton = UIButton(type: .system)
        checkButton.setImage(.done0.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .normal)
        checkButton.setImage(.done2.withTintColor(.challendarGreen100, renderingMode: .alwaysOriginal), for: .selected)
        checkButton.tintColor = .clear
        checkButton.isHidden = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        contentView.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.5),
            dateLabel.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 4),
            
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
        setupChartView()
    }
    
    private func setupChartView() {
        // 초기값으로 빈 차트 생성
        let pieChartView = PieChartView(dailyCompletionStatus: [])
        pieHostingController = UIHostingController(rootView: pieChartView)
        
        guard let hostingController = pieHostingController else { return }
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        contentView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            hostingController.view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 22),
            hostingController.view.widthAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
    }
      
    func configure(with item: TodoModel2) {
        titleLabel.text = item.name
        dateLabel.text = formatDate(item.endDate)
        stateLabel.text = calculateState(startDate: item.startDate, endDate: item.endDate)
        contentView.backgroundColor = .challendarBlack80
        
        // 차트를 업데이트
        if let dailyCompletionStatus = item.dailyCompletionStatus {
            updateChart(with: dailyCompletionStatus)
        }
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "날짜 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
    
    private func calculateState(startDate: Date?, endDate: Date?) -> String {
        guard let startDate = startDate, let endDate = endDate else { return "날짜 없음" }
        let today = Date()
        
        if today > endDate {
            return "종료됨,"
        } else if today < startDate {
            return "내일부터,"
        } else if Calendar.current.isDateInToday(startDate) {
            return "오늘부터,"
        } else {
            return "진행 중,"
        }
    }
    
    private func updateChart(with dailyCompletionStatus: [Bool?]) {
        let pieChartView = PieChartView(dailyCompletionStatus: dailyCompletionStatus)
        pieHostingController?.rootView = pieChartView
    }
}
