//
//  CalendarViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/23/22.
//

import UIKit

class CalendarViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var workoutCalendar: UIDatePicker!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToDatesDetailVC {
            guard let destination = segue.destination as? DatesDetailsViewController
            else { return }
            
            destination.chosenDate = workoutCalendar.date
        }
    }

}//End of class
