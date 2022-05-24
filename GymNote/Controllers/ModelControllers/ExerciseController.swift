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
    static let shared = ExerciseController()
    var exercises: [Exercise] = []
    
    private lazy var fetchRequest: NSFetchRequest<Exercise> = {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Exercise> = {
       let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: CoreDataManager.managedContext,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    //MARK: - CRUD funcs
    func saveExercise(newExercise: Exercise, workout: Workout) {
        //adding the new exercise to the array of exercises in the Workout Core Data class
        workout.addToExercises(newExercise)
        //adding the new exercise to the SOT array
        exercises.append(newExercise)
        CoreDataManager.shared.saveContext()
    }
    
    func update(exercise: Exercise, title: String) {
        //not allow user to change the exercise type
        exercise.title = title
        CoreDataManager.shared.saveContext()
    }
    
    func delete(exercise: Exercise, from workout: Workout) {
        guard let index = exercises.firstIndex(of: exercise) else { return }
        //delete all the sets belongs to this exercise
        let setsToDelete = SetController.shared.sets.filter{ $0.exercise == exercise }
        
        for exerciseSet in setsToDelete {
            SetController.shared.delete(set: exerciseSet, from: exercise)
        }
        //delete the exercise
        exercises.remove(at: index)
        workout.removeFromExercises(exercise)
        CoreDataManager.managedContext.delete(exercise)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    func fetchExerciseData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
        let fetchedExercises = fetchedResultsController.fetchedObjects ?? []
        self.exercises = fetchedExercises
    }
    
}//End of class

extension ExerciseController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Exercise Data is updated!!!!")
    }
    
}//End of extension
