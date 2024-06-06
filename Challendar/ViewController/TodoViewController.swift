//
//  TodoListViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit

class TodoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
        configureTitleNavigationBar(title: "할 일 목록")
        
    }

    override func configureNotificationCenter(){
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dismissedFromSuccess(_:)),
            name: NSNotification.Name("DismissSuccessView"),
            object: nil
        )
    }
    
    @objc func dismissedFromSuccess(_ notification: Notification) {

    }
    
}



