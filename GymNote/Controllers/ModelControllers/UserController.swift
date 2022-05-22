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
    func saveUserInfoWith(username: String, weight: Double, height: Double, prifileImage: UIImage?) {
        let newUser = User(username: username, weight: weight, height: height, prifileImage: prifileImage, context: CoreDataManager.managedContext)
        self.user = newUser
        CoreDataManager.shared.saveContext()
    }
    
    //MARK: - Helper Methods
    func fetchUserData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n--\n \(error)")
        }
        let fetchedUserObjects = fetchedResultsController.fetchedObjects ?? []
        guard let user = user,
              let index = fetchedUserObjects.firstIndex(of: user)
        else { return }
        let fetchedUser = fetchedUserObjects[index]
        self.user = fetchedUser
    }
    
}//End of class

extension UserController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("User Data is updated!!!!")
    }
    
}//End of extension
