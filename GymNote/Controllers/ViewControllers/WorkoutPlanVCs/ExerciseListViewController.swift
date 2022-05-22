//
//  FirstWorkoutSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/16/22.
//

import UIKit

class ExerciseListViewController: UIViewController {

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exerciseListTableView.reloadData()
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
        exerciseListTableView.dataSource = self
        
        guard let workoutTitle = workoutTitle,
              let repeatValue = repeatValue,
              let workoutStartingDates = workoutStartingDates,
              let user = UserController.shared.user
        else { return }
        //Create a new Workout Object here -> to avoid racing condition
        self.workoutTitleLabel.text = workoutTitle
        self.workoutDatesLabel.text = workoutStartingDates.datesFormatForWorkout()
        self.workout = Workout(title: workoutTitle, date: workoutStartingDates, user: user, repeatWorkout: repeatValue)
        guard let workout = workout else { return }
        WorkoutController.shared.saveWorkout(newWorkout: workout)
    }
    
    func userIsOnboarded() {
        UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
        storyboardManager.instantiateMainStoryboard()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToExerciseSetupVC {
            guard let workout = workout,
                  let destination = segue.destination as? ExerciseInfoSetupViewController
            else { return }
            
            destination.workout = workout
        } else if segue.identifier == StoryboardConstants.segueToExerciseDetails {
            guard let indexPath = exerciseListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? SetInfoSetupViewController,
                  let workout = workout
            else { return }
            
            let exerciseToSend = ExerciseController.shared.exercises.filter{ $0.workout == workout }[indexPath.row]
            
            destination.exercise = exerciseToSend
            destination.workout = workout
            destination.exerciseTitle = exerciseToSend.title
            destination.exerciseType = exerciseToSend.exerciseType
        }
    }

}//End of class

extension ExerciseListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseController.shared.exercises.filter{ $0.workout == workout }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exerciseListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.exerciseCellIdentifier, for: indexPath) as? ExerciseTableViewCell
        else { return UITableViewCell() }
        
        let exerciseToDisplay = ExerciseController.shared.exercises.filter{ $0.workout == workout }[indexPath.row]
        
        cell.updateViews(with: exerciseToDisplay)
        
        return cell
    }
    
}//End of extension