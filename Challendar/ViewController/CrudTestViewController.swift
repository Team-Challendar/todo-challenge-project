//
//  CrudTestViewController.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/25/24.
//

import UIKit

class CrudTestViewController: UIViewController {
//    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    let todoDummy = Todo(id: UUID(), title: "CRUD", memo: "혹시?", startDate: yesterday, endDate: tomorrow, completed: [yesterday: true, now: true, tomorrow: false], isChallenge: true, percentage: 33.3, images: nil, iscompleted: true, repetition: [1, 3, 5], reminderTime: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CoreDataManager.shared.deleteAllTodos()
//        CoreDataManager.shared.createTodo(newTodo: todoDummy)
    }
    
    
    

}
