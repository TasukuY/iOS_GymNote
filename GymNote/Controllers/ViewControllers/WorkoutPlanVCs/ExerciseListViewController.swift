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
    @IBOutlet weak var addNewExerciseButton: UIBarButtonItem!
    @IBOutlet weak var addExistingExerciseButton: UIButton!
    @IBOutlet weak var startTheWorkoutButton: UIButton!
    @IBOutlet weak var finishTheWorkoutbutton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //MARK: - Properties
    private let storyboardManager = StoryboardManager()
    var workout: Workout?
    var workoutTitle: String?
    var repeatValue: String?
    var workoutStartingDates: Date?
    var navPath: String?
    
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
        if navPath == nil {
            //If it is onboarding + workoutsetup storyboards
            if UserController.shared.user != nil {
                userIsOnboarded()
            } else {
                AlertManager.showUserSetupError(on: self)
            }
        } else {
            //if it is in the main storyboards
            for vc in (self.navigationController?.viewControllers ?? []) {
                //HomeVC NavPath
                if vc is HomeViewController {
                    if navPath == StoryboardConstants.navPathFromHomeVC {
                        navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                //CalendarVC NavPath
                } else if vc is DatesDetailsViewController {
                    if navPath == StoryboardConstants.navPathFromCalendarVC {
                        navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func addExistingExerciseButtonTapped(_ sender: Any) {}
    
    @IBAction func startTheWorkoutButtonTapped(_ sender: Any) {
        guard let workout = workout else { return }
        
        startTheWorkoutButton.isHidden = true
        finishTheWorkoutbutton.isHidden = false
        
        WorkoutController.shared.workoutIsStarted(workout: workout)
    }
    
    @IBAction func finishTheWorkoutButtonTapped(_ sender: Any) {
        guard let workout = workout else { return }
        
        finishTheWorkoutbutton.isHidden = true
        addNewExerciseButton.isEnabled = false
        addExistingExerciseButton.isHidden = true
        doneButton.isEnabled = false

        //TODO: - Delete all the sets that are not completed and exercises that do not have any sets
        
        let exercises = ExerciseController.shared.exercises.filter{ $0.workout == workout }
        
        for exercise in exercises {
            deleteNotCompletedSets(exercise: exercise)
        }
        
        for exercise in exercises {
            deleteExercisesWithNoSets(exercise: exercise, workout: workout)
        }
        
        WorkoutController.shared.workoutIsFinished(workout: workout)
    }
    
    //MARK: - Helper Methods
    func setupView() {
        exerciseListTableView.delegate = self
        exerciseListTableView.dataSource = self
        SetupAddExistingExerciseButton()
        
        guard let workoutTitle = workoutTitle,
              let repeatValue = repeatValue,
              let workoutStartingDates = workoutStartingDates,
              let user = UserController.shared.user
        else { return }
        self.workoutTitleLabel.text = workoutTitle
        self.workoutDatesLabel.text = workoutStartingDates.datesFormatForWorkout()
        
        if workout == nil {
            //Create a new Workout Object here -> to avoid racing condition
            self.workout = Workout(title: workoutTitle, date: workoutStartingDates, user: user, repeatWorkout: repeatValue)
            guard let workout = workout else { return }
            WorkoutController.shared.saveWorkout(newWorkout: workout)
        }
        
        setWorkoutReady()
        finishedWorkoutSetup()
    }
    
    func SetupAddExistingExerciseButton() {
        guard let workout = workout else { return }
        var menuChildren: [UIAction] = []
        let exercisesForSpecificWorkout = ExerciseController.shared.exercises.filter{ $0.workout?.title == workout.title }
        var exerciseTitleArr: [String] = []
        var uniqueExerciseTitleArr: [String] = []
        var uniqueExerciseArr: [Exercise] = []
        
        for exercise in exercisesForSpecificWorkout {
            guard let exerciseTitle = exercise.title else { return }
            exerciseTitleArr.append(exerciseTitle)
        }
        
        uniqueExerciseTitleArr = Array(Set(exerciseTitleArr))
        
        for exerciseTitle in uniqueExerciseTitleArr {
            if let uniqueExercise = exercisesForSpecificWorkout.first(where: { $0.title == exerciseTitle }) {
                uniqueExerciseArr.append(uniqueExercise)
            }
        }
        
        for exercise in uniqueExerciseArr {
            guard let exerciseTitle = exercise.title,
                  let exerciseType = exercise.exerciseType
            else { return }
            
            let existingExerciseUIAction = UIAction(title: exerciseTitle) { _ in
                let copiedExercise = Exercise(title: exerciseTitle, exerciseType: exerciseType, workout: workout)
                ExerciseController.shared.saveExercise(newExercise: copiedExercise, workout: workout)
                self.exerciseListTableView.reloadData()
            }
            menuChildren.append(existingExerciseUIAction)
        }

        let menu = UIMenu(title: "Exercises", image: nil, identifier: nil,
                          options: .displayInline,
                          children: menuChildren)
        addExistingExerciseButton.menu = menu
        addExistingExerciseButton.showsMenuAsPrimaryAction = true
        addExistingExerciseButton.titleLabel?.numberOfLines = 0
        addExistingExerciseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addExistingExerciseButton.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    func userIsOnboarded() {
        UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
        storyboardManager.instantiateMainStoryboard()
    }
    
    func setWorkoutReady() {
        guard let workout = workout,
              !workout.isFinished
        else { return }
        let today = Date()
        
        if workout.date?.datesFormatForWorkout() == today.datesFormatForWorkout() {
            startTheWorkoutButton.isHidden = false
        }
    }
    
    func finishedWorkoutSetup() {
        guard let workout = workout else { return }
        
        if workout.isFinished {
            addNewExerciseButton.isEnabled = false
            addExistingExerciseButton.isHidden = true
            doneButton.isEnabled = false
        }
        
        guard let workoutDates = workout.date,
              !Calendar.current.isDateInToday(workoutDates)
        else { return }
        let today = Date()
        
        if workoutDates < today {
            addNewExerciseButton.isEnabled = false
            addExistingExerciseButton.isHidden = true
            doneButton.isEnabled = false
        }
    }
    
    func deleteExercisesWithNoSets(exercise: Exercise, workout: Workout) {
        let setsNumber = SetController.shared.sets.filter{ $0.exercise == exercise }.count
        
        if setsNumber == 0 {
            ExerciseController.shared.delete(exercise: exercise, from: workout)
        }
    }
    
    func deleteNotCompletedSets(exercise: Exercise) {
        let sets = SetController.shared.sets.filter{ $0.exercise == exercise }
        
        for exerciseSet in sets {
            if exerciseSet.isCompleted == false && exerciseSet.note == nil {
                SetController.shared.delete(set: exerciseSet, from: exercise)
            }
        }
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
            destination.isWorkoutStarted = workout.isStarted
            destination.isWorkoutFinished = workout.isFinished
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let workout = workout else { return }
            let exerciseToDelete = ExerciseController.shared.exercises.filter{ $0.workout == workout }[indexPath.row]
            ExerciseController.shared.delete(exercise: exerciseToDelete, from: workout)
            exerciseListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}//End of extension
