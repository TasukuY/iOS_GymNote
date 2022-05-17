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
        guard let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.mainstoryboardID) as? TestViewController
        else { return }
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        //when we jump to the main storyboard if we do not see the tab bar controller, there is an error in this func
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func instantiateFirstWorkoutSetupStoryboard() {
        let storyboard = UIStoryboard(name: StoryboardConstants.firstWorkoutSetupStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.firstWorkoutSetupStoryboardID) as? FirstWorkoutTitleAndDaySetupViewController
        else { return }
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
}//End of struct
