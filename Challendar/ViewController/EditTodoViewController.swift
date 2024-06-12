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
    var newTodo : Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(checkFirst: true)
        
        titleLabel.backgroundColor = .systemPink
        titleView.backgroundColor = .cyan
        todoTextField.backgroundColor = .black
        
        dateAskLabel.backgroundColor = .blue
        dateAskView.backgroundColor = .green
    }
    
    
    override func configureConstraint(){
        
        
        titleView.addSubview(todoTextField)
        dateAskView.addSubview(dateView) // 나연님 짱..
        
        [titleLabel, titleView, dateAskLabel, dateAskView].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        todoTextField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(textFieldVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
        }
        
        dateAskLabel.snp.makeConstraints{
            $0.top.equalTo(titleView.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            
        }
        dateAskView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.top.equalTo(dateAskLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        
        dateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(dateLabelHorizontalPadding)
            $0.top.bottom.equalToSuperview().inset(dateLabelVerticalPadding)
        }
    }
}



