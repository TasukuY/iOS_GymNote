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
        request.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
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
    
    func update(user: User, username: String?, weight: Double?, height: Double?, profileImage: UIImage?) {
        if let newUsername = username {
            user.username = newUsername
        }
        if let newWeight = weight {
            user.weight = newWeight
        }
        if let newHeight = height {
            user.height = newHeight
        }
        if let newProfileImage = profileImage {
            user.profileImage = newProfileImage
        }

        CoreDataManager.shared.saveContext()
    }
    
    func delete(user: User) {
        //reset the UserDefaults to false
        UserDefaults.standard.set(false, forKey: StoryboardConstants.isOnboardedKey)
        //delete all workouts, exercises, and sets here
        let workoutsToDelete = WorkoutController.shared.workouts
        for workout in workoutsToDelete {
            WorkoutController.shared.delete(workout: workout, from: user)
        }
        //delete the user
        self.user = nil
        CoreDataManager.managedContext.delete(user)
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
        
        if fetchedUserObjects != [] {
            let fetchedUser = fetchedUserObjects.first
            self.user = fetchedUser
        }
    }
    
}//End of class

extension UserController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("User Data is updated!!!!")
    }
    
}//End of extension
