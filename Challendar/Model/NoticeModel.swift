//
//  NoticeModel.swift
//  Challendar
//
//  Created by Sam.Lee on 6/14/24.
//

import Foundation
// CloudKit에서 데이터 받아와서 공지사항에 띄워주기 위한 용
struct NoticeModel: Hashable {
    var title : String
    var content : String
    var timeStamp : Date
    var isopen : Bool = false
}
