//
//  AppDelegate.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/10/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        UserController.shared.saveUserInfo(with: "Test User", and: 200.0, and: 5.7)
//        guard let user = UserController.shared.user else { return false}
//        let testWorkout = Workout(title: "Test Workout", date: Date(), user: user, repeatWorkout: WorkoutConstants.repeatDaily)
//        guard let workoutTitle = testWorkout.title,
//              let workoutDate = testWorkout.date
//        else { return false }
//        WorkoutController.saveWorkout(with: workoutTitle, date: workoutDate, repeatValue: testWorkout.repeatWorkout ?? "Daily")
//        let exercise1 = Exercise(title: "Test Exercise1", exerciseType: ExerciseConstants.exerciseTypeWeightLifting, workout: testWorkout)
//        guard let exerciseTitle = exercise1.title,
//              let exerciseType = exercise1.exerciseType
//        else { return false }
//        ExerciseController.saveExercise(with: exerciseTitle, exerciseType: exerciseType, workout: testWorkout)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}//End of class

