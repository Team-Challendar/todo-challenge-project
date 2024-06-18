//
//  DetailCalendarCell.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/7/24.
//

import UIKit
import SnapKit
import FSCalendar

// 챌린지 세부페이지 캘린더용 cell
class DetailCalendarCell: UICollectionViewCell {
    static var identifier = "DetailCalendarCell"
    var calanderView = ChallengeDateCalendarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // cell 내부의 캘린더
    func configureCalenderView(todo: Todo){
        self.addSubview(calanderView)
        self.backgroundColor = .clear
        calanderView.currentTodo = todo
        calanderView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
