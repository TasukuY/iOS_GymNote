//
//  Workout+Convenience.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/16/22.
//

import UIKit
import CoreData

extension Workout {
    
    @discardableResult convenience init(title: String, date: Date, user: User, repeatWorkout: String,
                                        context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.title = title
        self.date = date
        self.repeatWorkout = repeatWorkout
        self.user = user
        self.exercises = []
    }
    
}//End of extension
