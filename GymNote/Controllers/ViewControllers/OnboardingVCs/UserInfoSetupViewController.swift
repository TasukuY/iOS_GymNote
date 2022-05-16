//
//  UserInfoSetUpViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/12/22.
//

import UIKit

class UserInfoSetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var feetTextField: UITextField!
    @IBOutlet weak var inchesTextField: UITextField!
    
    //MARK: - Properties
    let storyboardManager = StoryboardManager()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardFeatureSetup()
//        shouldPresentStoryboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shouldPresentStoryboard()
    }
    
    //MARK: - IBActions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
    
    //MARK: - Helper Methods
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        usernameTextField.delegate = self
        weightTextField.delegate = self
        feetTextField.delegate = self
        inchesTextField.delegate = self
    }
    
    func shouldPresentStoryboard() {
        if UserDefaults.standard.bool(forKey: StoryboardConstants.isOnboardedKey) {
            storyboardManager.instantiateMainStoryboard()
        }
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardConstants.segueToImageSetupVC {
            //Check Incomplete form
            guard let username = usernameTextField.text,
                  let weightInput = weightTextField.text,
                  let feetInput = feetTextField.text,
                  let inchesInput = inchesTextField.text,
                  !username.isEmpty,
                  !weightInput.isEmpty,
                  !feetInput.isEmpty,
                  !inchesInput.isEmpty
            else {
                AlertManager.showIncompleteFormAlert(on: self)
                return false
            }
            //Check Invalid Numbers
            if let _ = weightInput.doubleValue,
               let feet = feetInput.integerValue,
               let inches = inchesInput.integerValue,
               let _ = "\(feet).\(inches)".doubleValue {
                //Valid User Info
            } else {
                //Invalid Numbers
                AlertManager.showIncorrectInputTypeAlert(on: self)
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToImageSetupVC {
            guard let destination = segue.destination as? UserImageSetupViewController else { return }
            guard let username = usernameTextField.text,
                  let weightInput = weightTextField.text,
                  let feetInput = feetTextField.text,
                  let inchesInput = inchesTextField.text,
                  !username.isEmpty,
                  !weightInput.isEmpty,
                  !feetInput.isEmpty,
                  !inchesInput.isEmpty
            else { return }
            //Check Invalid Numbers
            if let weight = weightInput.doubleValue,
               let feet = feetInput.integerValue,
               let inches = inchesInput.integerValue,
               let height = "\(feet).\(inches)".doubleValue {
                destination.username = username
                destination.weight = weight
                destination.height = height
                destination.feet = feet
                destination.inches = inches
            }
        }
    }
    
    
}//End of class

extension UserInfoSetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
