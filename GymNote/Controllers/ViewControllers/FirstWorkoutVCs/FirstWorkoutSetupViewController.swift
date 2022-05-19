//
//  FirstWorkoutSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/16/22.
//

import UIKit

class FirstWorkoutSetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var workoutDatesLabel: UILabel!
    @IBOutlet weak var exerciseListTableView: UITableView!
    
    //MARK: - Properties
    private let storyboardManager = StoryboardManager()
    var workout: Workout?
    var workoutTitle: String?
    var repeatValue: String?
    var workoutStartingDates: Date?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        if UserController.shared.user != nil {
            userIsOnboarded()
        } else {
            AlertManager.showUserSetupError(on: self)
        }
    }
    
    //MARK: - Helper Methods
    func setupView() {
        exerciseListTableView.delegate = self

        guard let workoutTitle = workoutTitle,
              let repeatValue = repeatValue,
              let workoutStartingDates = workoutStartingDates,
              let user = UserController.shared.user
        else { return }
        
        workoutTitleLabel.text = workoutTitle
        workoutDatesLabel.text = workoutStartingDates.datesFormatForWorkout()
        workout = Workout(title: workoutTitle, date: workoutStartingDates, user: user, repeatWorkout: repeatValue)
        WorkoutController.saveWorkout(with: workoutTitle, date: workoutStartingDates, repeatValue: repeatValue)
    }
    
    func userIsOnboarded() {
        UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
        storyboardManager.instantiateMainStoryboard()
    }

}//End of class

extension FirstWorkoutSetupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exerciseListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.firstExerciseCellIdentifier, for: indexPath) as? FirstExerciseTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
    
    
    
    
}//End of extension
