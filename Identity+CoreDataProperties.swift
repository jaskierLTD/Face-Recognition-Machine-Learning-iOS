//
//  Identity+CoreDataProperties.swift
//  GetMeSocial
//
//  Created by Iorweth on 02/07/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var accuracy: Int16
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var imType: String?
    @NSManaged public var iValue: Int16
    @NSManaged public var lastModified: NSDate?
    @NSManaged public var lValue: Int16
    @NSManaged public var pName: String?
    @NSManaged public var rValue: Int16
    @NSManaged public var sValue: Int16
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var types: Type?

}
