import Foundation
import CloudKit

// CoreData 함수용 Manager 싱글톤 (공지사항용)
class CloudKitManager {
    
    static let shared = CloudKitManager()
    private init() {}
    
    // CloudKit에서 데이터 가져오기
    func fetchData(completion: @escaping ([NoticeModel]) -> Void) {
        var notices: [NoticeModel] = []
        let container = CKContainer(identifier: "iCloud.com.seungwon.Challendar") // 컨테이너 식별자가 올바른지 확인
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Notice", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        // 레코드가 매칭될 때 호출
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
        
        // 쿼리 결과가 완료될 때 호출되는 블록
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                print("Successfully completed query")
                completion(notices)
            case .failure(let error):
                print("Failed to complete query: \(error)")
            }
        }
        
        // 쿼리 작업을 공용 클라우드 컨테이너에 추가
        container.publicCloudDatabase.add(operation)
    }
}
