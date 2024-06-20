//
//  TodoModel+CoreDataProperties.swift
//  Challendar
//
//  Created by 채나연 on 6/19/24.
//

import Foundation
import CoreData

extension TodoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoModel> {
        return NSFetchRequest<TodoModel>(entityName: "TodoModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var memo: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var completed: [Bool]?
    @NSManaged public var isChallenge: Bool
    @NSManaged public var percentage: Double
    @NSManaged public var images: Data? // UIImage 대신 Data 타입 사용
    @NSManaged public var isCompleted: Bool
}

