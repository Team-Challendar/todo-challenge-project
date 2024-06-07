//
//  DetailCalendarCell.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/7/24.
//

import UIKit
import SnapKit
import FSCalendar

class DetailCalendarCell: FSCalendarCell {
    static var identifier = "DetailCalendarCell"
    var calanderView = TodoCalendarView()
//    private var challengeDateCalendarView: UIView = ChallengeDateCalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCalenderView(days: [Day]){
        self.addSubview(calanderView)
        calanderView.dayModelForCurrentPage = days
        calanderView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
