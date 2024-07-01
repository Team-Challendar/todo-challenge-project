//
//  TodoModel+CoreDataProperties.swift
//  Challendar
//
//  Created by Sam.Lee on 6/2/24.
//
//

import Foundation
import CoreData


extension TodoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoModel> {
        return NSFetchRequest<TodoModel>(entityName: "TodoModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String
    @NSManaged public var memo: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var completed: [Date: Bool]
    @NSManaged public var isChallenge: Bool
    @NSManaged public var percentage: Double
    @NSManaged public var images: Data?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var repetition: [Int]
    @NSManaged public var reminderTime: Date?
    @NSManaged public var notificationIdentifiers: [String]?
}

extension TodoModel : Identifiable {

}
