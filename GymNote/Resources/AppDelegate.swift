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

    var storyboardManager = StoryboardManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //fetch User, Workouts, Exercises, and Sets and update the SoT
        UserController.shared.fetchUserData()
        WorkoutController.shared.fetchWorkoutData()
        ExerciseController.shared.fetchExerciseData()
        SetController.shared.fetchSetData()
        WeightRecordController.shared.fetchWeightRecordData()

        if UserController.shared.user != nil {
            UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
        }
        
        //TableViewCell Setup
        let colorView = UIView()
        colorView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = colorView
        
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

