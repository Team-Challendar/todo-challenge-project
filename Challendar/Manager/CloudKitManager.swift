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
                print("Successfully fetched record: \(recordID)")
                if let title = record["title"] as? String,
                   let content = record["content"] as? String,
                   let timeStamp = record["timeStamp"] as? Date {
                    
                    let notice = NoticeModel(title: title, content: content, timeStamp: timeStamp)
                    notices.append(notice)
                } else {
                    print("Failed to parse record fields")
                }
            case .failure(let error):
                print("Failed to fetch record: \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                print("Successfully completed query")
                completion(notices)
            case .failure(let error):
                print("Failed to complete query: \(error)")
            }
        }
        
        container.publicCloudDatabase.add(operation)
    }
}
