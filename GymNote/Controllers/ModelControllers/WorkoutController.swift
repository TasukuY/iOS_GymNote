//
//  WorkoutController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import Foundation
import CoreData

class WorkoutController: NSObject {
    
    //MARK: - Properties
    private lazy var fetchRequest: NSFetchRequest<User> = {
        let request = NSFetchRequest<User>(entityName: "Workout")
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
    static func saveWorkout(with title: String, date: Date, repeatValue: String) {
        guard let user = UserController.shared.user else { return }
        let newWorkout = Workout(title: title, date: date, user: user, repeatWorkout: repeatValue)
        //adding the new workout to the array of workouts in the User Core Data class
        user.addToWorkouts(newWorkout)
        //adding the new workout to the SOT array in UserController class
        UserController.shared.add(newWorkout: newWorkout)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    
}//End of class

extension WorkoutController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Workout Data is updated!!!!")
    }
    
}//End of extension
