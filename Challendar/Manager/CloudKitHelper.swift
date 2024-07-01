import CloudKit

class CloudKitHelper {
    static let shared = CloudKitHelper()
    private let container: CKContainer
    private let database: CKDatabase
    
    private init() {
        container = CKContainer.default()
        database = container.privateCloudDatabase
    }
    
    func checkSchemaUpdateStatus(completion: @escaping (Bool) -> Void) {
        let recordID = CKRecord.ID(recordName: "SchemaUpdateStatus")
        database.fetch(withRecordID: recordID) { record, error in
            if let _ = record {
                completion(true)
            } else if let ckError = error as? CKError, ckError.code == .unknownItem {
                completion(false)
            } else {
                print("Error checking schema update status: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func markSchemaAsUpdated(completion: @escaping (Bool) -> Void) {
        let recordID = CKRecord.ID(recordName: "SchemaUpdateStatus")
        let record = CKRecord(recordType: "SchemaUpdateStatus", recordID: recordID)
        database.save(record) { record, error in
            if let _ = record {
                completion(true)
            } else {
                print("Error marking schema as updated: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
}
