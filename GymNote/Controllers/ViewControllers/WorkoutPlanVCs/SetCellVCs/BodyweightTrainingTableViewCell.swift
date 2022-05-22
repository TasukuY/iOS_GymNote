//
//  BodyweightTrainingTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

protocol BodyweightTrainingSetUpdatedDelegate: AnyObject {
    func isCompletedButtonTapped(sender: BodyweightTrainingTableViewCell)
    func setInfoGotUpdated(sender: BodyweightTrainingTableViewCell, newSetTyep: String?, newReps: Int?)
}

class BodyweightTrainingTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var setTypeButton: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var isCompletedButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: BodyweightTrainingSetUpdatedDelegate?
    var indexPath: IndexPath?
    
    //MARK: - IBActions
    @IBAction func setTypeButtonTapped(_ sender: Any) {
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
        if set.setType != nil && set.reps != 0 {
            setTypeButton.setTitle(set.setType, for: .normal)
            repsTextField.text = String(set.reps)
        } else {
            //New Empty Cell
            setTypeButton.setTitle(ExerciseConstants.setTypeMainSet, for: .normal)
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
              let newRepsStr = repsTextField.text,
              !newRepsStr.isEmpty
        else { return }
        
        let newReps = newRepsStr.integerValue
        guard let newReps = newReps else { return }
        
        delegate?.setInfoGotUpdated(sender: self, newSetTyep: newSetType, newReps: newReps)
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
        repsTextField.delegate = self
    }
    
}//End of class

extension BodyweightTrainingTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
