//
//  HomeViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/22/22.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutListTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var weightRecordOfTheDayTextField: UITextField!
    @IBOutlet weak var addNewWorkoutButton: UIButton!
    @IBOutlet weak var addExistingWorkoutButton: UIButton!
    @IBOutlet weak var noWorkoutLabel: UILabel!
    @IBOutlet weak var weightRecordSaveButton: UIButton!
    
    //MARK: - Properties
    var today: Date = Date()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchAllData()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupProfileImageView()
    }
    
    //MARK: - IBActions
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func addNewWorkoutButtonTapped(_ sender: Any) {}
    
    @IBAction func addExistingWorkoutButtonTapped(_ sender: Any) {}
    
    @IBAction func weightRecordSaveButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.user,
              let weightRecordofTheDay = weightRecordOfTheDayTextField.text,
              !weightRecordofTheDay.isEmpty
        else {
            AlertManager.showWeightRecordIsEmpty(on: self)
            return
        }
        
        guard let weightRecord = weightRecordofTheDay.doubleValue
        else {
            AlertManager.showIncorrectInputTypeAlert(on: self, correctValue: "numbers", targetFields: "the weight field")
            return
        }
        
        UserController.shared.update(user: user, username: nil, weight: weightRecord, height: nil, profileImage: nil)
        
        WeightRecordController.shared.addNewRecordWith(newWeight: weightRecord)
        isWeightRecordExist()
    }
    
    //MARK: - Helper Methods
    func fetchAllData() {
        //fetch User, Workouts, Exercises, Sets, and weightrecord, and update the SoT
        UserController.shared.fetchUserData()
        WorkoutController.shared.fetchWorkoutData()
        ExerciseController.shared.fetchExerciseData()
        SetController.shared.fetchSetData()
        WeightRecordController.shared.fetchWeightRecordData()
    }
    
    func setupView() {
        workoutListTableView.delegate = self
        workoutListTableView.dataSource = self
        
        setupAddExistingWorkoutButton()
        setupLabelsandButtons()
        setupNoWorkoutLabel()
        isWeightRecordExist()
        hideKeyboardFeatureSetup()
    }
    
    func setupProfileImageView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        
        guard let user = UserController.shared.user else { return }
        profileImageView.image = user.profileImage
    }
    
    func setupLabelsandButtons() {
        usernameLabel.numberOfLines = 0
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.lineBreakMode = .byWordWrapping
        
        weightRecordSaveButton.titleLabel?.numberOfLines = 0
        weightRecordSaveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        weightRecordSaveButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        guard let user = UserController.shared.user else { return }
        usernameLabel.text = user.username
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        weightRecordOfTheDayTextField.delegate = self
    }
    
    func setupNoWorkoutLabel() {
        let today = Date()
        if WorkoutController.shared.workouts.filter({ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }).count != 0 {
            noWorkoutLabel.isHidden = true
        } else {
            noWorkoutLabel.isHidden = false
        }
    }
    
    func isWeightRecordExist() {
        let weightRecordsOfTheDay = WeightRecordController.shared.weightRecords.filter{ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }
        
        if weightRecordsOfTheDay.count > 0 {
            guard let recordFortoday = weightRecordsOfTheDay.first else { return }
            weightRecordOfTheDayTextField.text = "\(recordFortoday.weight)"
            weightRecordOfTheDayTextField.isUserInteractionEnabled = false
            weightRecordSaveButton.isHidden = true
        } else {
            weightRecordOfTheDayTextField.text = ""
            weightRecordOfTheDayTextField.isUserInteractionEnabled = true
            weightRecordSaveButton.isHidden = false
        }
    }
    
    func setupAddExistingWorkoutButton() {
        var menuChildren: [UIAction] = []
        var workoutTitleArr: [String] = []
        var uniqueWorkoutTitleArr: [String] = []
        var uniqueWorkoutArr: [Workout] = []
        
        for workout in WorkoutController.shared.workouts {
            guard let workoutTitle = workout.title else { return }
            workoutTitleArr.append(workoutTitle)
        }
        
        uniqueWorkoutTitleArr = Array(Set(workoutTitleArr))
        
        for workoutTitle in uniqueWorkoutTitleArr {
            if let uniqueWorkout = WorkoutController.shared.workouts.first(where: { $0.title == workoutTitle }) {
                uniqueWorkoutArr.append(uniqueWorkout)
            }
        }
        
        for workout in uniqueWorkoutArr {
            guard let user = UserController.shared.user,
                  let workoutTitle = workout.title,
                  let repeatValue = workout.repeatWorkout
            else { return }
            
            let existingWorkoutUIAction = UIAction(title: workoutTitle) { _ in
                let copiedWorkoutWithNewDates = Workout(title: workoutTitle, date: self.today, user: user, repeatWorkout: repeatValue)
                WorkoutController.shared.saveWorkout(newWorkout: copiedWorkoutWithNewDates)
                self.setupNoWorkoutLabel()
                self.workoutListTableView.reloadData()
            }
            menuChildren.append(existingWorkoutUIAction)
        }

        let menu = UIMenu(title: "Workouts", image: nil, identifier: nil,
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
        if segue.identifier == StoryboardConstants.segueToCreateNewWorkoutVCFromHomeVC {
            guard let destination = segue.destination as? WorkoutInfoSetupViewController
            else { return }
            
            destination.navPath = StoryboardConstants.navPathFromHomeVC
            destination.chosenDate = today
        }
        if segue.identifier == StoryboardConstants.segueToExerciseListVCFromHomeVC {
            guard let indexPath = workoutListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? ExerciseListViewController
            else { return }
            
            let workoutToSend = WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }[indexPath.row]
            
            destination.workout = workoutToSend
            destination.workoutTitle = workoutToSend.title
            destination.repeatValue = WorkoutConstants.neverRepeat
            destination.workoutStartingDates = workoutToSend.date
            destination.navPath = StoryboardConstants.navPathFromHomeVC
        }
    }

}//End of class

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = workoutListTableView.dequeueReusableCell(withIdentifier: WorkoutConstants.workoutCellIdentifier, for: indexPath) as? WorkoutTableViewCell else { return UITableViewCell() }
        
        let workoutToDisplay = WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }[indexPath.row]
        
        cell.updateViews(with: workoutToDisplay)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let user = UserController.shared.user else { return }
            let workoutToDelete = WorkoutController.shared.workouts.filter{ $0.date?.datesFormatForWorkout() == today.datesFormatForWorkout() }[indexPath.row]
            WorkoutController.shared.delete(workout: workoutToDelete, from: user)
            workoutListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
}//End of extension

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Image",
                                            message: "How would you like to select an image?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func presentPhotoPicker() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let user = UserController.shared.user
        else { return }
        
        UserController.shared.update(user: user, username: nil, weight: nil, height: nil, profileImage: selectedImage)
        profileImageView.image = selectedImage

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}//End of extension

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
