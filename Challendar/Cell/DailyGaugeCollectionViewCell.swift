//
//  DailyGageCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/11/24.
//

import UIKit
import SnapKit

class DailyGaugeCollectionViewCell: UICollectionViewCell {
    static var identifier = "DailyGaugeCollectionViewCell"
    var gaugeBar : UIProgressView?
    var progrssLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gaugeBar?.progress = 0
    }
    func configure(day: Day){
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondary800
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.16
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        gaugeBar = UIProgressView(progressViewStyle: .bar)
        gaugeBar?.layer.cornerRadius = 18
//        gaugeBar?.layer.cornerCurve = .continuous
        gaugeBar?.clipsToBounds = true
        gaugeBar?.subviews[1].clipsToBounds = true
        gaugeBar?.trackTintColor = .secondary600
        gaugeBar?.progressTintColor = colorByPercentage(percentage: day.percentage)
        
        progrssLabel.text = "\(Int(day.percentage))%"
        progrssLabel.textColor = .challendarWhite
        progrssLabel.font = .pretendardMedium(size: 47)
        
        self.contentView.addSubview(gaugeBar!)
        self.contentView.addSubview(progrssLabel)
        gaugeBar!.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(44.5)
            $0.width.equalTo(144)
            $0.height.equalTo(36)
        }
        progrssLabel.snp.makeConstraints{
            $0.top.equalTo(gaugeBar!.snp.bottom).offset(8)
            $0.centerX.equalTo(gaugeBar!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            UIView.animate(withDuration: 0.5) {
                self.gaugeBar?.setProgress(Float(day.percentage / 100), animated: true)
                }
        })
       
    }
    private func colorByPercentage(percentage : Double) -> UIColor {
        switch percentage{
        case 0:
            return .clear
        case 0..<20:
            return .challendarBlue100
        case 20..<40:
            return .challendarBlue200
        case 40..<60:
            return .challendarBlue300
        case 60..<80:
            return .challendarBlue400
        case 80..<100:
            return .challendarBlue500
        case 100:
            return .challendarBlue600
        default:
            return .clear
        }
    }
}
