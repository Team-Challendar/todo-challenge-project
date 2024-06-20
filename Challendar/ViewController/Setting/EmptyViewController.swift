//
//  EmptyViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/13/24.
//

import UIKit
import SnapKit
// Test 용
class EmptyViewController: BaseViewController {

    var newCalendarView = NewCalendarView()
    var pickView = AlarmPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackAndTitleNavigationBar(title: "설정", checkSetting: true)
    }
    
    override func configureUI() {
        super.configureUI()
        
    }

    override func configureConstraint() {
        self.view.addSubview(newCalendarView)
        self.view.addSubview(pickView)
        let newTodo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.isChallenge == false && $0.endDate != nil
        })
        newCalendarView.configureWithTodo(todo: newTodo!)
        newCalendarView.translatesAutoresizingMaskIntoConstraints = false
        
        newCalendarView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.height.equalTo(320)
            $0.width.equalTo(300)
            $0.centerY.equalToSuperview()
        }
        pickView.snp.makeConstraints{
            $0.width.equalTo(300)
            $0.height.equalTo(126)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(newCalendarView.snp.bottom).offset(20)
        }
    }
}
