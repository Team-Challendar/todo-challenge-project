//
//  UITableViewController.swift
//  Challendar
//
//  Created by 채나연 on 6/28/24.
//

import UIKit
import AcknowList

extension UITableViewController {
    func configureBackAndTitleNavigationBar(title: String, checkSetting: Bool) {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        
        titleLabel.textColor = .challendarWhite
        titleLabel.backgroundColor = .clear
        
        let closeImageView = UIImageView()
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.image = .arrowLeftL
        closeImageView.backgroundColor = .clear
        
        [closeImageView,titleLabel].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(305)// 예시로 높이를 설정합니다. 필요에 따라 조정하세요.
        }
        
        closeImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(closeImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        if checkSetting {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
            titleLabel.font = .pretendardSemiBold(size: 20)
        }else{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
            titleLabel.font = .pretendardMedium(size: 20)
        }
        
        
        closeImageView.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        let titleBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension AcknowViewController {
    func configureBackAndTitleNavigationBar(title: String, checkSetting: Bool) {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        
        titleLabel.textColor = .challendarWhite
        titleLabel.backgroundColor = .clear
        
        let closeImageView = UIImageView()
        closeImageView.contentMode = .scaleAspectFill
        closeImageView.image = .arrowLeftL
        closeImageView.backgroundColor = .clear
        
        [closeImageView,titleLabel].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(305)// 예시로 높이를 설정합니다. 필요에 따라 조정하세요.
        }
        
        closeImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(closeImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeImageView.isUserInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer()
        if checkSetting {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
            titleLabel.font = .pretendardSemiBold(size: 20)
        }else{
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
            titleLabel.font = .pretendardMedium(size: 20)
        }
        
        
        closeImageView.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        let titleBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = titleBarButtonItem
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.title = ""
        self.configureBackAndTitleNavigationBar(title: "", checkSetting: false)
        self.textView?.backgroundColor = .secondary900
    }

}
