//
//  FirstWorkoutSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/16/22.
//

import UIKit

class FirstWorkoutSetupViewController: UIViewController {

    //MARK: - IBOutlets
    
    //MARK: - Properties
    private let storyboardManager = StoryboardManager()
    var user: User?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        if user != nil {
            userIsOnboarded()
        } else {
            AlertManager.showUserSetupError(on: self)
        }
    }
    
    //MARK: - Helper Methods
    func userIsOnboarded() {
        UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
        storyboardManager.instantiateMainStoryboard()
    }

}//End of class
