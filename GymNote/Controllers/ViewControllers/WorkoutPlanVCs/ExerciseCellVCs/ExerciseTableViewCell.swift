//
//  ExerciseTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/18/22.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    
    //MARK: - Helper Methods
    func updateViews(with exercise: Exercise) {
        exerciseTitleLabel.text = exercise.title
    }

}//End of class
