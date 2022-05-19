//
//  Exercise+Convenience.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/18/22.
//

import Foundation
import CoreData

extension Exercise {
    
    @discardableResult convenience init(title: String, exerciseType: String, workout: Workout,
                                        context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.title = title
        self.exerciseType = exerciseType
        self.workout = workout
        self.exerciseSets = []
    }
    
}//End of extension


