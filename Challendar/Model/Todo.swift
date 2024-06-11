//
//  Todo.swift
//  Challendar
//
//  Created by Sam.Lee on 6/2/24.
//

import UIKit

class Todo : Hashable{
    public var id : UUID?
    public var title: String
    public var memo: String?
    public var startDate: Date?
    public var endDate: Date? {
        didSet{
            guard let startDate = startDate else {return}
            completed = [Bool](repeating: false, count: ((endDate?.daysBetween(startDate) ?? 0) + 1))
        }
    }
    public var completed: [Bool] = []{
        didSet{
            percentage = Double(completed.filter{$0 == true}.count) / Double( completed.count)
        }
    }
    public var isChallenge: Bool = false
    public var percentage: Double = 0
    public var images: [UIImage]?
    public var iscompleted = false
    
    init(id: UUID? = nil, title: String = "", memo: String? = nil, startDate: Date? = nil, endDate: Date? = nil, completed: [Bool] = [], isChallenge: Bool = false, percentage: Double = 0, images: [UIImage]? = nil, iscompleted : Bool = false) {
        self.id = id
        self.title = title
        self.memo = memo
        self.startDate = startDate
        self.endDate = endDate
        self.completed = completed
        self.isChallenge = isChallenge
        self.percentage = percentage
        self.images = images
        self.iscompleted = iscompleted
    }
    
    func description(){
        print("----------")
        print("title: \(self.title)")
        print("memo: \(String(describing: self.memo))")
        print("startDate: \(self.startDate)")
        print("endDate: \(self.endDate)")
        print("completed.count: \(self.completed.count)")
        print("isChallenge: \(self.isChallenge)")
        print("percentage: \(self.percentage)")
        print("images.count:\(String(describing: self.images?.count))")
        print("isCompleted: \(self.iscompleted)")
        print("----------")
    }
    
    //MARK: - 오늘기준으로 Todo의 completed 값 리턴, 매개변수 추가 안할시에는 자동으로 오늘 기준
    func todayCompleted(date: Date = Date()) -> Bool?{
        if let startDate = startDate, let endDate = endDate{
            if (date.isBetween(startDate, endDate)){
                return self.completed[date.daysBetween(startDate)]
            }else{
                return nil
            }
        }
        return nil
    }
    
    //MARK: - 오늘기준으로 Todo의 completed 배열을 toggle
    func toggleTodaysCompletedState(){
        if let startDate = startDate, let endDate = endDate{
            if (Date.isTodayBetween(startDate, endDate)){
                let today = Date()
                self.completed[today.daysBetween(startDate)].toggle()
            }
        }
    }
    //MARK: - 주어진 date기준으로 Todo의 completed 배열을 toggle
    func toggleDatesCompletedState(date: Date){
        if let startDate = startDate, let endDate = endDate{
            if (date.isBetween(startDate, endDate)){
                self.completed[date.daysBetween(startDate)].toggle()
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(memo)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(completed)
        hasher.combine(isChallenge)
        hasher.combine(percentage)
        hasher.combine(images)
        hasher.combine(iscompleted)
    }
    
    // Equatable 프로토콜을 준수하도록 구현
    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.memo == rhs.memo && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.completed == rhs.completed && lhs.isChallenge == rhs.isChallenge && lhs.percentage == rhs.percentage && lhs.images == rhs.images && lhs.iscompleted == rhs.iscompleted
    }
}
