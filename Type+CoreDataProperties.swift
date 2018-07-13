//
//  Type+CoreDataProperties.swift
//  GetMeSocial
//
//  Created by Iorweth on 02/07/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import CoreData


extension Type
{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: "Type")
    }

    @NSManaged public var describe: String?
    @NSManaged public var imType: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var identities: NSSet?

}

// MARK: Generated accessors for identities
extension Type
{

    @objc(addIdentitiesObject:)
    @NSManaged public func addToIdentities(_ value: Identity)

    @objc(removeIdentitiesObject:)
    @NSManaged public func removeFromIdentities(_ value: Identity)

    @objc(addIdentities:)
    @NSManaged public func addToIdentities(_ values: NSSet)

    @objc(removeIdentities:)
    @NSManaged public func removeFromIdentities(_ values: NSSet)

}
