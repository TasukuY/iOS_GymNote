//
//  WeightLiftingSetsTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

protocol WeightLiftingSetUpdatedDelegate: AnyObject {
    func isCompletedButtonTapped(sender: WeightLiftingSetsTableViewCell)
    func setInfoGotUpdated(sender: WeightLiftingSetsTableViewCell, newSetTyep: String?, newWeight: Double?, newReps: Int?)
}

class WeightLiftingSetsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var setTypeButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var isCompletedButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: WeightLiftingSetUpdatedDelegate?
    var indexPath: IndexPath?
    
    //MARK: - IBActions
    @IBAction func setTypeButtonTapped(_ sender: Any) {
        delegateSetup()
    }
    
    @IBAction func weightTextFieldEditingDidEnd(_ sender: Any) {
        delegateSetup()
    }
    
    @IBAction func repsTextFieldEditingDidEnd(_ sender: UITextField) {
        delegateSetup()
    }
    
    @IBAction func isCompletedButtonTapped(_ sender: Any) {
        delegate?.isCompletedButtonTapped(sender: self)
    }
    
    //MARK: - Helper Methods
    func updateViews(with set: ExerciseSet) {
        if set.weight != 0 && set.reps != 0 && set.setType != nil {
            setTypeButton.setTitle(set.setType, for: .normal)
            weightTextField.text = String(set.weight)
            repsTextField.text = String(set.reps)
        } else {
            //New Empty Cell
            setTypeButton.setTitle(ExerciseConstants.setTypeMainSet, for: .normal)
            weightTextField.text = ""
            repsTextField.text = ""
        }
        
        if set.isCompleted {
            isCompletedButton.setImage(UIImage(systemName: ExerciseConstants.exerciseCompletedImage), for: .normal)
        } else {
            isCompletedButton.setImage(UIImage(systemName: ExerciseConstants.exerciseNotCompletedImage), for: .normal)
        }
    }
    
    func delegateSetup() {
        guard let newSetType = setTypeButton.titleLabel?.text,
              let newWeightStr = weightTextField.text,
              let newRepsStr = repsTextField.text,
              !newWeightStr.isEmpty,
              !newRepsStr.isEmpty
        else { return }
        
        let newWeight = newWeightStr.doubleValue
        let newReps = newRepsStr.integerValue
        
        guard let newWeight = newWeight,
              let newReps = newReps
        else { return }
        
        delegate?.setInfoGotUpdated(sender: self, newSetTyep: newSetType, newWeight: newWeight, newReps: newReps)
    }
    
    func setupSetTypeButton() {
        let mainSet = UIAction(title: ExerciseConstants.setTypeActiontitleMainSet, image: nil) { _ in
            self.setTypeButton.setTitle(ExerciseConstants.setTypeMainSet, for: .normal)
        }
        let superSet = UIAction(title: ExerciseConstants.setTypeActiontitleSuperSet, image: nil) { _ in
            self.setTypeButton.setTitle(ExerciseConstants.setTypeSuperSet, for: .normal)
        }
        let warmupSet = UIAction(title: ExerciseConstants.setTypeActiontitleWarmupSet, image: nil) { _ in
            self.setTypeButton.setTitle(ExerciseConstants.setTypeWarmupSet, for: .normal)
        }
        let menu = UIMenu(title: "Set Type Menu", image: nil, identifier: nil,
                          options: .displayInline,
                          children: [mainSet, superSet, warmupSet])
        setTypeButton.menu = menu
        setTypeButton.showsMenuAsPrimaryAction = true
        setTypeButton.titleLabel?.numberOfLines = 0
        setTypeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setTypeButton.titleLabel?.lineBreakMode = .byWordWrapping
    }

    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.contentView, action: #selector(UITableViewCell.endEditing(_:)))
        contentView.addGestureRecognizer(tap)
        weightTextField.delegate = self
        repsTextField.delegate = self
    }
    
}//End of class

extension WeightLiftingSetsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
