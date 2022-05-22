//
//  CardioSetsTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

protocol CardioSetUpdatedDelegate: AnyObject {
    func isCompletedButtonTapped(sender: CardioSetsTableViewCell)
    func setInfoGotUpdated(sender: CardioSetsTableViewCell, newDistance: Double?, newDuration: Int?)
}

class CardioSetsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var isCompletedButton: UIButton!
    
    //MARK: - Properties
    weak var delegate: CardioSetUpdatedDelegate?
    var indexPath: IndexPath?
    
    //MARK: - IBActions
    @IBAction func isCompletedButtonTapped(_ sender: Any) {
        delegate?.isCompletedButtonTapped(sender: self)
    }
    
    @IBAction func distanceTextFieldEditingDidEnd(_ sender: UITextField) {
        delegateSetup()
    }
    
    @IBAction func durationTextFieldEditingDidEnd(_ sender: UITextField) {
        delegateSetup()
    }
    
    //MARK: - Helper Methods
    func updateViews(with set: ExerciseSet) {
        if set.distance != 0 && set.duration != 0 {
            distanceTextField.text = String(set.distance)
            durationTextField.text = String(set.duration)
        } else {
            //New Empty Cell
            distanceTextField.text = ""
            durationTextField.text = ""
        }
        
        if set.isCompleted {
            isCompletedButton.setImage(UIImage(systemName: ExerciseConstants.exerciseCompletedImage), for: .normal)
        } else {
            isCompletedButton.setImage(UIImage(systemName: ExerciseConstants.exerciseNotCompletedImage), for: .normal)
        }
    }
    
    func delegateSetup() {
        guard let newDistanceStr = distanceTextField.text,
              let newDurationStr = durationTextField.text,
              !newDistanceStr.isEmpty,
              !newDurationStr.isEmpty
        else { return }
        
        let newDistance = newDistanceStr.doubleValue
        let newDuration = newDurationStr.integerValue
        
        guard let newDistance = newDistance,
              let newDuration = newDuration
        else { return }
        
        delegate?.setInfoGotUpdated(sender: self, newDistance: newDistance, newDuration: newDuration)
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.contentView, action: #selector(UITableViewCell.endEditing(_:)))
        contentView.addGestureRecognizer(tap)
        distanceTextField.delegate = self
        durationTextField.delegate = self
    }

}//End of class

extension CardioSetsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}//End of extension
