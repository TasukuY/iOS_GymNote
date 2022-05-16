//
//  UserController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/11/22.
//

import UIKit
import CoreData

class UserController: NSObject {
    
    //MARK: - Properties
    static let shared = UserController()
    let workouts: [Workout] = []
    var user: User?
    
    //CoreData+CloudKit
    private lazy var fetchRequest: NSFetchRequest<User> = {
        let request = NSFetchRequest<User>(entityName: "User")
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
    func saveUserInfo(with username: String, and weight: Double, and height: Double) {
        let newUser = User(username: username, weight: weight, height: height, context: CoreDataManager.managedContext)
        self.user = newUser
        CoreDataManager.shared.saveContext()
    }
    
    func fetchUserData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    //MARK: - Helper Methods
    
}//End of class

extension UserController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("User Data is updated!!!!")
    }
    
}//End of extension
