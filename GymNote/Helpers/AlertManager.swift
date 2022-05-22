//
//  AlertManager.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/15/22.
//

import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete Form", message: "Please fill out all fields in the form")
    }
    
    static func showIncorrectInputTypeAlert(on vc: UIViewController, correctValue: String, targetFields: String) {
        showBasicAlert(on: vc, with: "Invalid Input Type", message: "Please type \(correctValue) in \(targetFields)")
    }
    
    static func showUserSetupError(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "User Setup Error", message: "Error occured while setting up your account. Please re-do the set up process again.")
    }
    
    static func showTitleEmptyAlert(on vc: UIViewController, target: String) {
        showBasicAlert(on: vc, with: "\(target) title is Empty", message: "Please set the title for this \(target)")
    }
    
    static func showSetWorkoutRepeatValueAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Repeat Value is not set", message: "Please set the Repeat Value for this Workout")
    }
    
    static func showExerciseTypeError(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Exercise Type is not set", message: "Please set the Type of the Exercise")
    }
    
}//End of class
