//
//  WeightRecord+Convenience.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/23/22.
//

import Foundation
import CoreData

extension WeightRecord {
    
    @discardableResult convenience init(weight: Double, date: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.weight = weight
        self.date = date
    }
    
}//End of extension
