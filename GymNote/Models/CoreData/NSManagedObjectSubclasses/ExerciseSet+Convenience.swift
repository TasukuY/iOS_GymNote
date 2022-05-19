//
//  ExerciseSet+Convenience.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import Foundation
import CoreData

extension ExerciseSet {
    
    @discardableResult convenience init(exercise: Exercise, setType: String?, weight: Double?, reps: Int?, distance: Double?, duration: Int?, note: String?, context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.exercise = exercise
        self.setType = setType
        self.weight = weight ?? 0.0
        self.reps = Int64(reps ?? 0)
        self.distance = distance ?? 0
        self.duration = Int64(duration ?? 0)
        self.note = note
        self.isCompleted = false
    }
    
}//End of extension
