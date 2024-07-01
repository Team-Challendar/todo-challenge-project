import Foundation

@objc(IntArrayTransformer)
class IntArrayTransformer: ValueTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [Int] else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            return data
        } catch {
            print("Failed to transform array to data: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let array = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: data) as? [Int]
            return array
        } catch {
            print("Failed to reverse transform data to array: \(error)")
            return nil
        }
    }
}
