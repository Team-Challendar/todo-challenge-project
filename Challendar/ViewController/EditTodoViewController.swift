//
//  EditTodoViewController.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/12/24.
//

import UIKit
import SnapKit

class EditTodoTitleViewController: BaseViewController {
    
    // 계획 질문 UI 컴포넌트
    let titleLabel = EditTitleLabel(text: "어떤 계획이 생겼나요?")
    let titleView = EmptyView()
    
    let todoTextField = TodoTitleTextField(placeholder: "고양이 츄르 주문하기")
    
    // 기한 질문 UI 컴포넌트
    let dateAskLabel = EditTitleLabel(text: "기한을 선택해주세요")
    let dateAskView = EmptyView()
    let dateView = DateView()
    
    var newTodo: Todo?
    var todoId: UUID? // 전달받은 투두의 ID를 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(checkFirst: true)
        fetchTodo()
    }
    
    override func configureConstraint() {
        titleView.addSubview(todoTextField)
        dateAskView.addSubview(dateView)
        
        [titleLabel, titleView, dateAskLabel, dateAskView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        todoTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(textFieldVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
        }
        
        dateAskLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        dateAskView.snp.makeConstraints {
            $0.height.equalTo(cellHeight)
            $0.top.equalTo(dateAskLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        
        dateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
        }
    }
    
    private func fetchTodo() {
        guard let todoId = todoId, let todoModel = CoreDataManager.shared.fetchTodoById(id: todoId) else {
            print("Todo not found")
            return
        }
        
        // 투두의 제목을 텍스트 필드에 설정
        todoTextField.text = todoModel.title
        
        // 투두의 날짜 범위를 dateView에 설정
        if let startDate = todoModel.startDate, let endDate = todoModel.endDate {
            if startDate.isSameDay(as: endDate) {
                dateView.textLabel.text = DateRange.today.rawValue
            } else if startDate.isSameDay(as: Date().addingDays(-1)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.tomorrow.rawValue
            } else if startDate.isSameDay(as: Date().addingDays(-7)!) && endDate.isSameDay(as: Date()) {
                dateView.textLabel.text = DateRange.week.rawValue
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. M. d"
                let startDateString = dateFormatter.string(from: startDate)
                let endDateString = dateFormatter.string(from: endDate)
                dateView.textLabel.text = "\(startDateString) - \(endDateString)"
            }
        }
    }
}
