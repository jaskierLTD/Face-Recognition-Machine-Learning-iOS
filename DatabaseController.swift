//
//  DatabaseController.swift
//  GetMeSocial
//
//  Created by Iorweth on 30/06/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController: NSObject
{
    private override init() { }
    
    class func getContext() -> NSManagedObjectContext
    {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    static var persistentContainer: NSPersistentContainer =
    {
        let container = NSPersistentContainer.init(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    class func saveContext ()
    {
            let context = persistentContainer.viewContext
            if context.hasChanges
            {
                do {
                    try context.save()
                }
                catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
    }
}
