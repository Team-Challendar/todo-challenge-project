//
//  CloudKitManager.swift
//  Challendar
//
//  Created by Sam.Lee on 6/14/24.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    static let shared = CloudKitManager()
    private init() {}
    
    func fetchData(completion: @escaping ([NoticeModel]) -> Void)  {
        var notices : [NoticeModel] = []
        let container = CKContainer(identifier: "iCloud.com.seungwon.Challendar")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Notice", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.publicCloudDatabase
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                //                for (key, value) in record {
                //                    print("\(key): \(value)")
                //                }
                if let title = record["title"] as? String,
                   let content = record["content"] as? String,
                   let timeStamp = record["timeStamp"] as? Date {
                    
                    let notice = NoticeModel(title: title, content: content, timeStamp: timeStamp)
                    notices.append(notice)
                }
            case .failure(let error):
                print("Failed to fetch record: \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success(let _):
                completion(notices)
            case .failure(let _):
                print("FETCH ERROR")
            }
        }

        
        operation.start()
        
    }
    
}
