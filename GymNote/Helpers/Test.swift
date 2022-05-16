//extension User {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
//        return NSFetchRequest<User>(entityName: "User")
//    }
//
//    @NSManaged public var height: Double
//    @NSManaged public var username: String?
//    @NSManaged public var weight: Double
//    @NSManaged public var workouts: NSSet?
//
//}
//
//extension User {
//
//    @objc(addWorkoutsObject:)
//    @NSManaged public func addToWorkouts(_ value: Workout)
//
//    @objc(removeWorkoutsObject:)
//    @NSManaged public func removeFromWorkouts(_ value: Workout)
//
//    @objc(addWorkouts:)
//    @NSManaged public func addToWorkouts(_ values: NSSet)
//
//    @objc(removeWorkouts:)
//    @NSManaged public func removeFromWorkouts(_ values: NSSet)
//
//}
//extension Workout {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
//        return NSFetchRequest<Workout>(entityName: "Workout")
//    }
//
//    @NSManaged public var date: Date?
//    @NSManaged public var title: String?
//    @NSManaged public var exercises: NSSet?
//    @NSManaged public var user: User?
//
//}
//
//extension Workout {
//
//    @objc(addExercisesObject:)
//    @NSManaged public func addToExercises(_ value: Exercise)
//
//    @objc(removeExercisesObject:)
//    @NSManaged public func removeFromExercises(_ value: Exercise)
//
//    @objc(addExercises:)
//    @NSManaged public func addToExercises(_ values: NSSet)
//
//    @objc(removeExercises:)
//    @NSManaged public func removeFromExercises(_ values: NSSet)
//
//}
//
//extension Exercise {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
//        return NSFetchRequest<Exercise>(entityName: "Exercise")
//    }
//
//    @NSManaged public var exerciseType: String?
//    @NSManaged public var title: String?
//    @NSManaged public var sets: NSSet?
//    @NSManaged public var workout: Workout?
//
//}
//
//extension Exercise {
//
//    @objc(addSetsObject:)
//    @NSManaged public func addToSets(_ value: WoukoutSet)
//
//    @objc(removeSetsObject:)
//    @NSManaged public func removeFromSets(_ value: WoukoutSet)
//
//    @objc(addSets:)
//    @NSManaged public func addToSets(_ values: NSSet)
//
//    @objc(removeSets:)
//    @NSManaged public func removeFromSets(_ values: NSSet)
//
//}
//
//extension WoukoutSet {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<WoukoutSet> {
//        return NSFetchRequest<WoukoutSet>(entityName: "WoukoutSet")
//    }
//
//    @NSManaged public var distance: Double
//    @NSManaged public var duration: Int64
//    @NSManaged public var isCompleted: Bool
//    @NSManaged public var reps: Int64
//    @NSManaged public var setType: String?
//    @NSManaged public var weight: Double
//    @NSManaged public var exercise: Exercise?
//
//}
//
