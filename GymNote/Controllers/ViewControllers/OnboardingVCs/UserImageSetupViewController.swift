//
//  UserImageSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/14/22.
//

import UIKit

class UserImageSetupViewController: UIViewController {

    //MARK: - IBOutlets
    
    //MARK: - Properties
    var username: String?
    var weight: Double?
    var height: Double?
    var feet: Int?
    var inches: Int?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Helper Methods
    func setupView() {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.segueToAccountConfirmationVC {
            guard let destination = segue.destination as? UserInfoConfirmationViewController,
                  let username = username,
                  let weight = weight,
                  let height = height,
                  let feet = feet,
                  let inches = inches
            else { return }
            destination.username = username
            destination.weight = weight
            destination.height = height
            destination.feet = feet
            destination.inches = inches
        }
    }
    
}//End of class
