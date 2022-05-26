//
//  WeightRecordController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/23/22.
//

import Foundation
import CoreData

class WeightRecordController: NSObject {
    
    //MARK: - Properties
    static let shared = WeightRecordController()
    var weightRecords: [WeightRecord] = []
    
    private lazy var fetchRequest: NSFetchRequest<WeightRecord> = {
        let request = NSFetchRequest<WeightRecord>(entityName: "WeightRecord")
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<WeightRecord> = {
       let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                  managedObjectContext: CoreDataManager.managedContext,
                                                  sectionNameKeyPath: nil,
                                                  cacheName: nil)
        fetchedRC.delegate = self
        return fetchedRC
    }()
    
    //MARK: - CRUD funcs
    func addNewRecordWith(newWeight: Double) {
        guard UserController.shared.user != nil else { return }
        //adding the new workout to the array of workouts in the User Core Data class
        let newWeightRecord = WeightRecord(weight: newWeight, context: CoreDataManager.managedContext)
        //adding the new workout to the SOT array
        weightRecords.append(newWeightRecord)
        CoreDataManager.shared.saveContext()
    }
    
    //TODO: - Enable to update weight record info
    func update(weightRecord: WeightRecord, newWeight: Double) {
        weightRecord.weight = newWeight
        CoreDataManager.shared.saveContext()
    }
    
    func delete() {
        //delete all weight records
        for weightRecord in weightRecords {
            CoreDataManager.managedContext.delete(weightRecord)
        }
        weightRecords.removeAll()
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods for CoreData
    func fetchWeightRecordData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
        let fetchedWeightRecords = fetchedResultsController.fetchedObjects ?? []
        self.weightRecords = fetchedWeightRecords
    }
    
    
}//End of class

extension WeightRecordController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Weight Record Data is updated!!!!")
    }
    
}//End of extension
