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
    static let shared = SetController()
    var sets: [ExerciseSet] = []
    
    private lazy var fetchRequest: NSFetchRequest<ExerciseSet> = {
        let request = NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "setType", ascending: true)]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ExerciseSet> = {
       let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: CoreDataManager.managedContext,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    //MARK: - CRUD funcs
    func saveSets(for exercise: Exercise, newSet: ExerciseSet) {
        //adding the new set to the array of exercise sets in the Exercise Core Data class
        exercise.addToExerciseSets(newSet)
        //adding the new set to the SOT array
        sets.insert(newSet, at: 0)
        CoreDataManager.shared.saveContext()
    }
    
    func update(set: ExerciseSet, newSetType: String?, newWeight: Double?, newReps: Int?, newDistance: Double?, newDuration: Int?, newNote: String?) {
        if let newSetType = newSetType {
            set.setType = newSetType
        }
        if let newWeight = newWeight  {
            set.weight = newWeight
        }
        if let newReps = newReps {
            set.reps = Int64(newReps)
        }
        if let newDistance = newDistance {
            set.distance = newDistance
        }
        if let newDuration = newDuration {
            set.duration = Int64(newDuration)
        }
        if let newNote = newNote {
            set.note = newNote
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    func toggleIsCompletedState(of set: ExerciseSet) {
        set.isCompleted = !set.isCompleted
        CoreDataManager.shared.saveContext()
    }
    
    func delete(set: ExerciseSet, from exercise: Exercise) {
        guard let index = sets.firstIndex(of: set) else { return }
        sets.remove(at: index)
        exercise.removeFromExerciseSets(set)
        CoreDataManager.managedContext.delete(set)
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    func fetchSetData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
        let fetchedSets = fetchedResultsController.fetchedObjects ?? []
        self.sets = fetchedSets
    }
    
}//End of class

extension SetController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Exercise Sets Data is updated!!!!")
    }
    
}//End of extension
