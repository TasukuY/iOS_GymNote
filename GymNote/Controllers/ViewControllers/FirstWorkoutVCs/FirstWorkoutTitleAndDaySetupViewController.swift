//
//  FirstWorkoutTitleAndDaySetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/16/22.
//

import UIKit

class FirstWorkoutTitleAndDaySetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutTitleTextField: UITextField!
    @IBOutlet weak var workoutStartingDates: UIDatePicker!
    @IBOutlet weak var howOftenRepeatWorkoutButton: UIButton!
    
    //MARK: - Properties
    var user: User?
    var workout: Workout?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardFeatureSetup()
    }
    
    //MARK: - IBActions
    
    //MARK: - Helper Methods
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        workoutTitleTextField.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}//End of class

extension FirstWorkoutTitleAndDaySetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
