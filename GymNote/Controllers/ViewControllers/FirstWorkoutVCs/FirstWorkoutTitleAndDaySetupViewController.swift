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
    var workout: Workout?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func nextButtonTapped(_ sender: Any) {}
    
    //MARK: - Helper Methods
    func setupView() {
        hideKeyboardFeatureSetup()
        setupHowOftenRepeatWorkoutButton()
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        workoutTitleTextField.delegate = self
    }
    
    func setupHowOftenRepeatWorkoutButton() {
        let repeatDaily = UIAction(title: WorkoutConstants.repeatDaily, image: nil) { _ in
            self.howOftenRepeatWorkoutButton.setTitle(WorkoutConstants.repeatDaily, for: .normal)
            print("Button Title: \(self.howOftenRepeatWorkoutButton.titleLabel?.text ?? "")")
        }
        
        let repeatWeekly = UIAction(title: WorkoutConstants.repeatWeekly, image: nil) { _ in
            self.howOftenRepeatWorkoutButton.setTitle(WorkoutConstants.repeatWeekly, for: .normal)
            print("Button Title: \(self.howOftenRepeatWorkoutButton.titleLabel?.text ?? "")")
        }
        
        let repeatEveryOtherWeek = UIAction(title: WorkoutConstants.repeatEveryOtherWeek, image: nil) { _ in
            self.howOftenRepeatWorkoutButton.setTitle(WorkoutConstants.repeatEveryOtherWeek, for: .normal)
            print("Button Title: \(self.howOftenRepeatWorkoutButton.titleLabel?.text ?? "")")
        }
        
        let repeatEveryMonth = UIAction(title: WorkoutConstants.repeatEveryMonth, image: nil) { _ in
            self.howOftenRepeatWorkoutButton.setTitle(WorkoutConstants.repeatEveryMonth, for: .normal)
            print("Button Title: \(self.howOftenRepeatWorkoutButton.titleLabel?.text ?? "")")
        }
        
        let neverRepeat = UIAction(title: WorkoutConstants.neverRepeat, image: nil) { _ in
            self.howOftenRepeatWorkoutButton.setTitle(WorkoutConstants.neverRepeat, for: .normal)
            print("Button Title: \(self.howOftenRepeatWorkoutButton.titleLabel?.text ?? "")")
        }
        
        let menu = UIMenu(title: "Repeat Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: [repeatDaily, repeatWeekly, repeatEveryOtherWeek, repeatEveryMonth, neverRepeat])
        howOftenRepeatWorkoutButton.menu = menu
        howOftenRepeatWorkoutButton.showsMenuAsPrimaryAction = true
        howOftenRepeatWorkoutButton.titleLabel?.numberOfLines = 0
        howOftenRepeatWorkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        howOftenRepeatWorkoutButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == StoryboardConstants.segueToFirstWorkoutSetupVC {
            if workoutTitleTextField.text == "" {
                AlertManager.showWorkoutTitleEmptyAlert(on: self)
                return false
            }
            
            if howOftenRepeatWorkoutButton.titleLabel!.text == WorkoutConstants.defaultRepeatValue {
                AlertManager.showSetWorkoutRepeatValueAlert(on: self)
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToFirstWorkoutSetupVC {
            guard let destination = segue.destination as? FirstWorkoutSetupViewController else { return }
            
            guard UserController.shared.user != nil,
                  let workoutTitle = workoutTitleTextField.text,
                  let repeatValue = howOftenRepeatWorkoutButton.titleLabel?.text
            else { return }
            
            let workoutStartingDates = workoutStartingDates.date
            
            destination.workoutTitle = workoutTitle
            destination.workoutStartingDates = workoutStartingDates
            destination.repeatValue = repeatValue
        }
    }

}//End of class

extension FirstWorkoutTitleAndDaySetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
