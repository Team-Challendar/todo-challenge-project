import Foundation
import CoreData

@objc(DictionaryTransformer)
class DictionaryTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let dictionary = value as? [Date: Bool] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
            return data
        } catch {
            print("Failed to transform dictionary to data: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let dictionary = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSDate.self, NSNumber.self], from: data) as? [Date: Bool]
            return dictionary
        } catch {
            print("Failed to reverse transform data to dictionary: \(error)")
            return nil
        }
    }
}
