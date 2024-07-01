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
    var newPickerView = CustomAlarmView()
    var testview = UIView()
    
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
        self.view.addSubview(newPickerView)
        self.view.addSubview(testview)
        
        testview.layer.cornerRadius = 68
        testview.layer.cornerCurve = .continuous
        
        let newTodo = CoreDataManager.shared.fetchTodos().first(where: {
            $0.isChallenge == false && $0.endDate != nil
        })
        newCalendarView.configureWithTodo(todo: newTodo!)
        newCalendarView.translatesAutoresizingMaskIntoConstraints = false
        newCalendarView.isHidden = true
        testview.backgroundColor = .white
        
        testview.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.size.equalTo(200)
        }
        
        newCalendarView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.height.equalTo(320)
            $0.width.equalTo(300)
            $0.top.equalToSuperview().offset(100)
        }
        pickView.snp.makeConstraints{
            $0.width.equalTo(300)
            $0.height.equalTo(126)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(newCalendarView.snp.bottom).offset(20)
        }
        newPickerView.snp.makeConstraints{
            $0.width.equalTo(300)
            $0.height.equalTo(126)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pickView.snp.bottom).offset(20)
        }
    }
}
