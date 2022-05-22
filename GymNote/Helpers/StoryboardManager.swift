//
//  StoryboardManager.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import UIKit

struct StoryboardManager {
        
    //MARK: - Helper Methods
    func presentStoryboard(window: UIWindow?) {
        guard let window = window
        else { return }
        
        if UserDefaults.standard.bool(forKey: StoryboardConstants.isOnboardedKey) {
            let storyboard = UIStoryboard(name: StoryboardConstants.mainstoryboard, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            let storyboard = UIStoryboard(name: StoryboardConstants.onboardingStoryboard, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
    }
    
    func instantiateMainStoryboard() {
        let storyboard = UIStoryboard(name: StoryboardConstants.mainstoryboard, bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.mainStoryboardTabController)
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        //when we jump to the main storyboard if we do not see the tab bar controller, there is an error in this func
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
    }
    
    func instantiateWorkoutSetupStoryboard() {
        let storyboard = UIStoryboard(name: StoryboardConstants.workoutSetupStoryboard, bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.workoutSetupNavController)
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
}//End of struct
