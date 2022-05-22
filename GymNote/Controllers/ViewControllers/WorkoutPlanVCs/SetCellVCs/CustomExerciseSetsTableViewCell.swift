//
//  CustomExerciseSetsTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/19/22.
//

import UIKit

protocol CustomExerciseSetUpdatedDelegate: AnyObject {
    func setInfoGotUpdated(sender: CustomExerciseSetsTableViewCell, newNotes: String?)
}

class CustomExerciseSetsTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var noteTextField: UITextView!

    //MARK: - Properties
    weak var delegate: CustomExerciseSetUpdatedDelegate?
    var indexPath: IndexPath?
    
    //MARK: - Helper Methods
    func updateViews(with set: ExerciseSet) {
        if let note = set.note {
            noteTextField.text = note
        } else {
            //New Empty Cell
            noteTextField.text = "enter notes here..."
        }
    }
    
    func delegateSetup() {
        guard let newNotes = noteTextField.text,
              !newNotes.isEmpty
        else { return }
        
        delegate?.setInfoGotUpdated(sender: self, newNotes: newNotes)
    }
    
    func hideKeyboardFeatureSetup() {
        let tap = UITapGestureRecognizer(target: self.contentView, action: #selector(UITableViewCell.endEditing(_:)))
        contentView.addGestureRecognizer(tap)
        noteTextField.delegate = self
    }
    
}//End of class

extension CustomExerciseSetsTableViewCell: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegateSetup()
    }
    
}//End of extension
