//
//  Todo.swift
//  Challendar
//
//  Created by Sam.Lee on 6/2/24.
//

import UIKit

class Todo {
    public var id : UUID?
    public var title: String
    public var memo: String?
    public var startDate: Date?
    public var endDate: Date? {
        didSet{
            guard let startDate = startDate else {return}
            completed = [Bool](repeating: false, count: endDate?.daysBetween(startDate) ?? 0)
            print(completed.count)
        }
    }
    public var completed: [Bool] = []
    public var isChallenge: Bool = false
    public var percentage: Double = 0
    public var images: [UIImage]?
    
    init(id: UUID? = nil, title: String = "", memo: String? = nil, startDate: Date? = nil, endDate: Date? = nil, completed: [Bool] = [], isChallenge: Bool = false, percentage: Double = 0, images: [UIImage]? = nil) {
        self.id = id
        self.title = title
        self.memo = memo
        self.startDate = startDate
        self.endDate = endDate
        self.completed = completed
        self.isChallenge = isChallenge
        self.percentage = percentage
        self.images = images
    }
}
