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
