//
//  SetController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import Foundation
import  CoreData

class SetController: NSObject {
    
    //MARK: - Properties
    private lazy var fetchRequest: NSFetchRequest<User> = {
        let request = NSFetchRequest<User>(entityName: "ExerciseSet")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<User> = {
       let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: CoreDataManager.managedContext,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    //MARK: - CRUD funcs
    static func saveSets(for exercise: Exercise, setType: String?, weight: Double?, reps: Int?, distance: Double?, duration: Int?, note: String?) {
        let newSet = ExerciseSet(exercise: exercise, setType: setType, weight: weight, reps: reps, distance: distance, duration: duration, note: note)
        //adding the new set to the array of exercise sets in the Exercise Core Data class
        exercise.addToExerciseSets(newSet)
        //adding the new set to the SOT array in UserController class
        UserController.shared.add(newExerciseSets: newSet)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    
    
}//End of class

extension SetController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Exercise Sets Data is updated!!!!")
    }
    
}//End of extension
