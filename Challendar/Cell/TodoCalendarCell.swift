//
//  TodoCalendarCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/5/24.
//

import UIKit
import SnapKit

class TodoCalendarCell: UICollectionViewCell {
    static var identifier = "TodoCalendarCell"
    var calanderView = TodoCalendarView()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    func configureCalenderView(days: [Day]){
        self.addSubview(calanderView)
        calanderView.dayModelForCurrentPage = days
        calanderView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
