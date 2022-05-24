//
//  WorkoutTableViewCell.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/23/22.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    //MARK: - Helper Methods
    func updateViews(with workout: Workout) {
        workoutTitleLabel.text = workout.title
    }

}//End of class
