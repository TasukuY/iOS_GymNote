//
//  WorkoutController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import Foundation
import CoreData
import UIKit

class WorkoutController: NSObject {
    
    //MARK: - Properties
    static let shared = WorkoutController()
    var workouts: [Workout] = []
    
    private lazy var fetchRequest: NSFetchRequest<Workout> = {
        let request = NSFetchRequest<Workout>(entityName: "Workout")
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Workout> = {
       let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: CoreDataManager.managedContext,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    
    //MARK: - CRUD funcs
    func saveWorkout(newWorkout: Workout) {
        guard let user = UserController.shared.user else { return }
        //adding the new workout to the array of workouts in the User Core Data class
        user.addToWorkouts(newWorkout)
        //adding the new workout to the SOT array
        workouts.append(newWorkout)
        CoreDataManager.shared.saveContext()
    }
    
    func update(workout: Workout, title: String?, date: Date?, repeatWorkout: String?) {
        if let newTitle = title {
            workout.title = newTitle
        }
        if let newDate = date {
            workout.date = newDate
        }
        if let newRepeatWorkout = repeatWorkout {
            workout.repeatWorkout = newRepeatWorkout
        }
        CoreDataManager.shared.saveContext()
    }
    
    func workoutIsCompleted(workout: Workout) {
        workout.isCompleted = true
    }
    
    func delete(workout: Workout, from user: User) {
        guard let index = workouts.firstIndex(of: workout) else { return }
        //delete all the exercises belongs to this workout
        let exercisesToDelete = ExerciseController.shared.exercises.filter{ $0.workout == workout }
        
        for exercise in exercisesToDelete {
            ExerciseController.shared.delete(exercise: exercise, from: workout)
        }
        //delete the workout
        workouts.remove(at: index)
        user.removeFromWorkouts(workout)
        CoreDataManager.managedContext.delete(workout)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods for CoreData
    func fetchWorkoutData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
        let fetchedWorkouts = fetchedResultsController.fetchedObjects ?? []
        self.workouts = fetchedWorkouts
    }
    
}//End of class

extension WorkoutController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Workout Data is updated!!!!")
    }
    
}//End of extension
