//
//  NoticeModel.swift
//  Challendar
//
//  Created by Sam.Lee on 6/14/24.
//

import Foundation

struct NoticeModel: Hashable {
    var title : String
    var content : String
    var timeStamp : Date
    var isopen : Bool = false
}
