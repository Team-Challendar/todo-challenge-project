//
//  ViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

class TodoCalendarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFloatingButton()
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

