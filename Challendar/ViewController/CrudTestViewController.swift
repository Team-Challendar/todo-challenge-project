//
//  CrudTestViewController.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/25/24.
//

import UIKit

class CrudTestViewController: UIViewController {
    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CoreDataManager.shared.deleteAllTodos()
        CoreDataManager.shared.createTodo(newTodo: todoDummy)
        print(self.todoItems)
    }
    
    
    

}
