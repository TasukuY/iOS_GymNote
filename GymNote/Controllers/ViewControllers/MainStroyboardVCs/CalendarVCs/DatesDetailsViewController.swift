//
//  DatesDetailsViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/23/22.
//

import UIKit

class DatesDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var workoutSectionLabel: UILabel!
    @IBOutlet weak var addNewWorkoutButton: UIButton!
    @IBOutlet weak var addExistingWorkoutButton: UIButton!
    @IBOutlet weak var noWorkoutSetLabel: UILabel!
    
    //MARK: - Properties
    var chosenDate: Date?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func addNewWorkoutButtonTapped(_ sender: Any) {}
    @IBAction func addExistingWorkoutButtonTapped(_ sender: Any) {}
    
    //MARK: - Helper Methods
    func setupView() {
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        
        setupAddExistingWorkoutButton()
        setupNoWorkoutLabel()
        setupWorkoutSectionLabel()
    }
    
    func setupWorkoutSectionLabel() {
        guard let chosenDate = chosenDate else { return }
        workoutSectionLabel.text = "\(chosenDate.datesFormatForWorkout())'s Workout"
        workoutSectionLabel.numberOfLines = 0
        workoutSectionLabel.adjustsFontSizeToFitWidth = true
        workoutSectionLabel.lineBreakMode = .byWordWrapping
    }
    
    func setupNoWorkoutLabel() {
        guard let chosenDate = chosenDate else { return }
        if WorkoutController.shared.workouts.filter({ $0.date?.datesFormatForWorkout() == chosenDate.datesFormatForWorkout() }).count != 0 {
            noWorkoutSetLabel.isHidden = true
        } else {
            noWorkoutSetLabel.isHidden = false
        }
    }
    
    func setupAddExistingWorkoutButton() {
        var menuChildren: [UIAction] = []
        
        //How to eliminate workouts that has the same title
        for workout in WorkoutController.shared.workouts {
            guard let workoutTitle = workout.title,
                  let repeatWorkout = workout.repeatWorkout,
                  let user = UserController.shared.user,
                  let chosenDate = chosenDate
            else { return }
            
            let existingWorkoutUIAction = UIAction(title: workoutTitle) { _ in
                let copiedWorkoutWithNewDates = Workout(title: workoutTitle, date: chosenDate, user: user, repeatWorkout: repeatWorkout)
                WorkoutController.shared.saveWorkout(newWorkout: copiedWorkoutWithNewDates)
                self.setupNoWorkoutLabel()
                self.workoutListTableView.reloadData()
            }
            menuChildren.append(existingWorkoutUIAction)
        }

        let menu = UIMenu(title: "Repeat Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuChildren)
        addExistingWorkoutButton.menu = menu
        addExistingWorkoutButton.showsMenuAsPrimaryAction = true
        addExistingWorkoutButton.titleLabel?.numberOfLines = 0
        addExistingWorkoutButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addExistingWorkoutButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToCreateNewWorkoutVCFromCalendarVC {
            guard let destination = segue.destination as? WorkoutInfoSetupViewController,
                  let chosenDate = chosenDate
            else { return }
        
            destination.chosenDate = chosenDate
            destination.navPath = StoryboardConstants.navPathFromCalendarVC
        }
        if segue.identifier == StoryboardConstants.segueToExerciseListVCFromCalendarVC {
            guard let indexPath = workoutListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? ExerciseListViewController,
                  let chosenDate = chosenDate
            else { return }
            
            let workoutToSend = WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == chosenDate.datesFormatForWorkout() }[indexPath.row]
            
            destination.workout = workoutToSend
            destination.workoutTitle = workoutToSend.title
            destination.repeatValue = WorkoutConstants.neverRepeat
            destination.workoutStartingDates = workoutToSend.date
            destination.navPath = StoryboardConstants.navPathFromHomeVC
        }
    }

}//End of class

extension DatesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chosenDate = chosenDate else { return 0 }
        return WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == chosenDate.datesFormatForWorkout() }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = workoutListTableView.dequeueReusableCell(withIdentifier: WorkoutConstants.workoutCellIdentifier, for: indexPath) as? WorkoutTableViewCell else { return UITableViewCell() }
        
        let workoutToDisplay = WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == chosenDate?.datesFormatForWorkout() }[indexPath.row]
        
        cell.updateViews(with: workoutToDisplay)
        
        return cell
    }
    
}//End of extension
