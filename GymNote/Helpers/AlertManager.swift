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
    
    static func showIncorrectInputTypeAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Invalid Input Type", message: "Please type numbers in weight and height fields")
    }
    
    static func showUserSetupError(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "User Setup Error", message: "Error occured while setting up your account. Please re-do the set up process again.")
    }
    
}//End of class
