//
//  User+CoreDataProperties.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/21/22.
//
//

import UIKit
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var height: Double
    @NSManaged public var profileImage: UIImage?
    @NSManaged public var username: String?
    @NSManaged public var weight: Double
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension User {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

extension User : Identifiable {

}
