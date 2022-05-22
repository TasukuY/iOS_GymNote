//
//  ExerciseInfoSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

class ExerciseInfoSetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var exerciseTitleTextField: UITextField!
    @IBOutlet weak var exerciseTypeButton: UIButton!
    
    //MARK: - Properties
    var workout: Workout?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func exerciseTypeButtonTapped(_ sender: Any) {}
    @IBAction func nextButtonTapped(_ sender: Any) {}
    
    //MARK: - Helper Methods
    func setupView() {
        hideKeyboardFeatureSetup()
        setupExerciseTypeButton()
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        exerciseTitleTextField.delegate = self
    }
    
    func setupExerciseTypeButton() {
        let cardio = UIAction(title: ExerciseConstants.exerciseTypeCardio, image: nil) { _ in
            self.exerciseTypeButton.setTitle(ExerciseConstants.exerciseTypeCardio, for: .normal)
        }
        let weightLifting = UIAction(title: ExerciseConstants.exerciseTypeWeightLifting, image: nil) { _ in
            self.exerciseTypeButton.setTitle(ExerciseConstants.exerciseTypeWeightLifting, for: .normal)
        }
        let bodyweightTraining = UIAction(title: ExerciseConstants.exerciseTypeBodyWeightTraining, image: nil) { _ in
            self.exerciseTypeButton.setTitle(ExerciseConstants.exerciseTypeBodyWeightTraining, for: .normal)
        }
        let customExercise = UIAction(title: ExerciseConstants.exerciseTypeCustom, image: nil) { _ in
            self.exerciseTypeButton.setTitle(ExerciseConstants.exerciseTypeCustom, for: .normal)
        }
        let menu = UIMenu(title: "Exercise Type Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: [cardio, weightLifting, bodyweightTraining, customExercise])
        exerciseTypeButton.menu = menu
        exerciseTypeButton.showsMenuAsPrimaryAction = true
        exerciseTypeButton.titleLabel?.numberOfLines = 0
        exerciseTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        exerciseTypeButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardConstants.segueToSetsVC {
            if exerciseTitleTextField.text == "" {
                AlertManager.showTitleEmptyAlert(on: self, target: "Exercise")
                return false
            }
            
            if exerciseTypeButton.titleLabel!.text == ExerciseConstants.exerciseTypeDefaultValue {
                AlertManager.showExerciseTypeError(on: self)
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToSetsVC {
            guard let workout = workout,
                  let exerciseTitle = exerciseTitleTextField.text,
                  let exerciseType = exerciseTypeButton.titleLabel?.text,
                  let destination = segue.destination as? SetInfoSetupViewController
            else { return }
            
            destination.workout = workout
            destination.exerciseTitle = exerciseTitle
            destination.exerciseType = exerciseType
        }
    }

}//End of class

extension ExerciseInfoSetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
