//import Foundation
//
//@objc(NSDictionaryTransformer)
//class NSDictionaryTransformer: NSSecureUnarchiveFromDataTransformer {
//    static let name = NSValueTransformerName(rawValue: String(describing: NSDictionaryTransformer.self))
//
//    override static var allowedTopLevelClasses: [AnyClass] {
//        return [NSDictionary.self, NSDate.self, NSNumber.self]
//    }
//
//    public static func register() {
//        let transformer = NSDictionaryTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
//}
//
//@objc(RepetitionCycleTransformer)
//class RepetitionCycleTransformer: NSSecureUnarchiveFromDataTransformer {
//    static let name = NSValueTransformerName(rawValue: String(describing: RepetitionCycleTransformer.self))
//
//    override static var allowedTopLevelClasses: [AnyClass] {
//        return [NSDictionary.self, NSArray.self, NSNumber.self, NSDateComponents.self]
//    }
//
//    public static func register() {
//        let transformer = RepetitionCycleTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
//}
//
//@objc(DateComponentsTransformer)
//class DateComponentsTransformer: NSSecureUnarchiveFromDataTransformer {
//    static let name = NSValueTransformerName(rawValue: String(describing: DateComponentsTransformer.self))
//
//    override static var allowedTopLevelClasses: [AnyClass] {
//        return [DateComponents.self]
//    }
//
//    public static func register() {
//        let transformer = DateComponentsTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
//}
