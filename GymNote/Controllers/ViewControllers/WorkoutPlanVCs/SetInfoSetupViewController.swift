//
//  SetInfoSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

class SetInfoSetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var setsListTableView: UITableView!
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    @IBOutlet weak var addSetButton: UIButton!
    
    //MARK: - Properties
    var workout: Workout?
    var exercise: Exercise?
    var exerciseTitle: String?
    var exerciseType: String?
    var isWorkoutStarted: Bool = false
    var isWorkoutFinished: Bool = false
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func addSetButtonTapped(_ sender: Any) {
        addNewEmptyCell()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        deleteAllNilSets()

        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is ExerciseListViewController {
                navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }

    //MARK: - Helper Methods
    func setupView() {
        setsListTableView.delegate = self
        setsListTableView.dataSource = self
        hideKeyboardFeatureSetup()
        
        guard let workout = workout,
              let exerciseTitle = exerciseTitle,
              let exerciseType = exerciseType
        else { return }
        exerciseTitleLabel.text = exerciseTitle
        
        if exercise == nil {
            //Create a new Exercise Object here -> to avoid race condition
            exercise = Exercise(title: exerciseTitle, exerciseType: exerciseType, workout: workout)
            guard let exercise = exercise else { return }
            ExerciseController.shared.saveExercise(newExercise: exercise, workout: workout)
        }
        
        if isWorkoutFinished {
            addSetButton.isHidden = true
        }
    }
    
    func addNewEmptyCell() {
        guard let exercise = exercise else { return }
        
        let newSet = ExerciseSet(exercise: exercise, setType: nil, weight: nil, reps: nil, distance: nil, duration: nil, note: nil)
        
        SetController.shared.saveSets(for: exercise, newSet: newSet)
        self.setsListTableView.reloadData()
    }
    
    func deleteAllNilSets() {
        guard let exercise = exercise else { return }
        let setsToCheck = SetController.shared.sets.filter{ $0.exercise == exercise }
        
        for exerciseSet in setsToCheck {
            if exerciseSet.setType == "No Type" && exerciseSet.note == nil && exerciseSet.weight == 0 && exerciseSet.reps == 0 && exerciseSet.distance == 0 && exerciseSet.duration == 0 {
                //if the set is an empty set, delete it
                SetController.shared.delete(set: exerciseSet, from: exercise)
            }
        }
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
}//End of class

extension SetInfoSetupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetController.shared.sets.filter{ $0.exercise == exercise }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exercise = exercise,
              let exerciseType = exercise.exerciseType
        else { return UITableViewCell() }
        
        switch exerciseType {
        case ExerciseConstants.exerciseTypeCardio:
            guard let cell = setsListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.cardioSetCellIdentifier, for: indexPath) as? CardioSetsTableViewCell
            else { return UITableViewCell() }
            let setToDisplay = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.hideKeyboardFeatureSetup()
            cell.updateViews(with: setToDisplay, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
            
            return cell
        
        case ExerciseConstants.exerciseTypeWeightLifting:
            guard let cell = setsListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.weightLiftingSetCellIdentifier, for: indexPath) as? WeightLiftingSetsTableViewCell
            else { return UITableViewCell() }
            let setToDisplay = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.hideKeyboardFeatureSetup()
            cell.setupSetTypeButton()
            cell.updateViews(with: setToDisplay, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
            
            return cell
        
        case ExerciseConstants.exerciseTypeBodyWeightTraining:
            guard let cell = setsListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.bodyweightTrainingCellIdentifier, for: indexPath) as? BodyweightTrainingTableViewCell
            else { return UITableViewCell() }
            let setToDisplay = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.hideKeyboardFeatureSetup()
            cell.setupSetTypeButton()
            cell.updateViews(with: setToDisplay, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
            
            return cell
        
        case ExerciseConstants.exerciseTypeCustom:
            guard let cell = setsListTableView.dequeueReusableCell(withIdentifier: ExerciseConstants.customExerciseSetCellIdentifier, for: indexPath) as? CustomExerciseSetsTableViewCell
            else { return UITableViewCell() }
            let setToDisplay = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
            
            cell.indexPath = indexPath
            cell.delegate = self
            cell.hideKeyboardFeatureSetup()
            cell.updateViews(with: setToDisplay, isWorkoutFinished: isWorkoutFinished)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let exercise = exercise else { return }
            let setToDelete = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
            SetController.shared.delete(set: setToDelete, from: exercise)
            setsListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}//End of extension

extension SetInfoSetupViewController: CardioSetUpdatedDelegate {

    //Update the set when the value got updated
    func setInfoGotUpdated(sender: CardioSetsTableViewCell, newDistance: Double?, newDuration: Int?) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.update(set: setToUpdate, newSetType: nil, newWeight: nil, newReps: nil, newDistance: newDistance, newDuration: newDuration, newNote: nil)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }

    func isCompletedButtonTapped(sender: CardioSetsTableViewCell) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.toggleIsCompletedState(of: setToUpdate)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
    
}//End of extension

extension SetInfoSetupViewController: WeightLiftingSetUpdatedDelegate {
    
    func setInfoGotUpdated(sender: WeightLiftingSetsTableViewCell, newSetTyep: String?, newWeight: Double?, newReps: Int?) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.update(set: setToUpdate, newSetType: newSetTyep, newWeight: newWeight, newReps: newReps, newDistance: nil, newDuration: nil, newNote: nil)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
    
    func isCompletedButtonTapped(sender: WeightLiftingSetsTableViewCell) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.toggleIsCompletedState(of: setToUpdate)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
    
}//End of extension

extension SetInfoSetupViewController: BodyweightTrainingSetUpdatedDelegate {

    func setInfoGotUpdated(sender: BodyweightTrainingTableViewCell, newSetTyep: String?, newReps: Int?) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.update(set: setToUpdate, newSetType: newSetTyep, newWeight: nil, newReps: newReps, newDistance: nil, newDuration: nil, newNote: nil)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
    
    func isCompletedButtonTapped(sender: BodyweightTrainingTableViewCell) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.toggleIsCompletedState(of: setToUpdate)
        sender.updateViews(with: setToUpdate, isWorkoutStarted: isWorkoutStarted, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
        
}//End of extension

extension SetInfoSetupViewController: CustomExerciseSetUpdatedDelegate {
    
    func setInfoGotUpdated(sender: CustomExerciseSetsTableViewCell, newNotes: String?) {
        guard let indexPath = sender.indexPath,
              let exercise = exercise
        else { return }
        let setToUpdate = SetController.shared.sets.filter{ $0.exercise == exercise}[indexPath.row]
        SetController.shared.update(set: setToUpdate, newSetType: nil, newWeight: nil, newReps: nil, newDistance: nil, newDuration: nil, newNote: newNotes)
        sender.updateViews(with: setToUpdate, isWorkoutFinished: isWorkoutFinished)
        setsListTableView.reloadData()
    }
    
}//End of extension

extension SetInfoSetupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
