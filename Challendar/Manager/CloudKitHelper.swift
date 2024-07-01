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
        database.fetch(withRecordID: SchemaUpdateStatus.recordID) { record, error in
            if let record = record, let schemaUpdateStatus = SchemaUpdateStatus(record: record) {
                completion(schemaUpdateStatus.isUpdated)
            } else if let ckError = error as? CKError, ckError.code == .unknownItem {
                completion(false)
            } else {
                print("Error checking schema update status: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func markSchemaAsUpdated(completion: @escaping (Bool) -> Void) {
        database.fetch(withRecordID: SchemaUpdateStatus.recordID) { record, error in
            if let record = record {
                // 레코드가 존재하면 업데이트
                record["isUpdated"] = true as CKRecordValue
                self.database.save(record) { savedRecord, saveError in
                    if let saveError = saveError {
                        print("Error updating schema as updated: \(saveError.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else if let ckError = error as? CKError, ckError.code == .unknownItem {
                // 레코드가 존재하지 않으면 새로 생성
                let schemaUpdateStatus = SchemaUpdateStatus(isUpdated: true)
                let newRecord = schemaUpdateStatus.toRecord()
                self.database.save(newRecord) { savedRecord, saveError in
                    if let saveError = saveError {
                        print("Error marking schema as updated: \(saveError.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                print("Error fetching schema update status: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
}

class SchemaUpdateStatus {
    static let recordType = "SchemaUpdateStatus"
    static let recordID = CKRecord.ID(recordName: "SchemaUpdateStatus")

    var isUpdated: Bool

    init(isUpdated: Bool) {
        self.isUpdated = isUpdated
    }

    init?(record: CKRecord) {
        guard let isUpdated = record["isUpdated"] as? Bool else { return nil }
        self.isUpdated = isUpdated
    }

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: SchemaUpdateStatus.recordType, recordID: SchemaUpdateStatus.recordID)
        record["isUpdated"] = isUpdated as CKRecordValue
        return record
    }
}
