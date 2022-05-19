//
//  ExerciseController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import Foundation
import CoreData

class ExerciseController: NSObject {
    
    //MARK: - Properties    
    private lazy var fetchRequest: NSFetchRequest<User> = {
        let request = NSFetchRequest<User>(entityName: "Exercise")
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
    static func saveExercise(with title: String, exerciseType: String, workout: Workout) {
        let newExercise = Exercise(title: title, exerciseType: exerciseType, workout: workout)
        //adding the new exercise to the array of exercises in the Workout Core Data class
        workout.addToExercises(newExercise)
        //adding the new exercise to the SOT array in UserController class
        UserController.shared.add(newExercise: newExercise)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    
}//End of class

extension ExerciseController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Exercise Data is updated!!!!")
    }
    
}//End of extension
