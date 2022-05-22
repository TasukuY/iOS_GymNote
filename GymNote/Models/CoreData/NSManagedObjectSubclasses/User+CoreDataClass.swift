//
//  User+CoreDataClass.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/21/22.
//
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {}

extension User {
    
    @discardableResult convenience init(username: String, weight: Double, height: Double, prifileImage: UIImage?,
                                        context: NSManagedObjectContext = CoreDataManager.managedContext) {
        self.init(context: context)
        self.username = username
        self.profileImage = prifileImage ?? UIImage(systemName: UserConstants.defaultProfileImage)
        self.weight = weight
        self.height = height
        self.workouts = []
    }
    
}//End of extension
