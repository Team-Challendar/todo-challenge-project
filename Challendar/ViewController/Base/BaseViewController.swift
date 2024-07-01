//
//  BaseViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/1/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureUI()
        configureConstraint()
        configureUtil()
        configureNotificationCenter()
    }
    
    func configureUI(){}
    func configureConstraint(){}
    func configureUtil(){}
    func configureNotificationCenter(){}
}
