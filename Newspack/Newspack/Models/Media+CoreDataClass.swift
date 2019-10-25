import Foundation
import CoreData

@objc(Media)
public class Media: NSManagedObject, MediaTypeDiscerner {

    @nonobjc public class func defaultFetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

}
