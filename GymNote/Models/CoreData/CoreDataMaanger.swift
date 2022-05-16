//
//  CoreDataMaanger.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentCloudKitContainer = {//step1
        let container = NSPersistentCloudKitContainer(name: "GymNote")//step2
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var managedContext: NSManagedObjectContext {//step3
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true //step4
        return context
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}//End of class
