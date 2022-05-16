//
//  User+Convenience.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/15/22.
//

import UIKit
import CoreData

extension User {
    
    @discardableResult convenience init(username: String, weight: Double, height: Double,
                                        context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.username = username
        self.weight = weight
        self.height = height
    }
    
}//End of extension
