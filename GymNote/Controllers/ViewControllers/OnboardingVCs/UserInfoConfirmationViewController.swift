//
//  UserInfoSetUP3ViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import UIKit

class UserInfoConfirmationViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var doneSetupButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var feetLabel: UILabel!
    @IBOutlet weak var inchesLabel: UILabel!
    
    //MARK: - Properties
    private let storyboardManager = StoryboardManager()
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
    
    //MARK: - IBActions
    @IBAction func doneSetupButtonTapped(_ sender: Any) {
        setupUserInfo()
        if UserController.shared.user != nil {
//            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
                self.storyboardManager.instantiateFirstWorkoutSetupStoryboard()
//            }
        } else {
            AlertManager.showUserSetupError(on: self)
        }
    }
    
    //MARK: - Helper Methods
    func setupUserInfo() {
        guard let username = username,
              let weight = weight,
              let height = height
        else { return }
        UserController.shared.saveUserInfo(with: username, and: weight, and: height)
    }
    
    func setupView() {
        guard let username = username,
              let weight = weight,
              let feet = feet,
              let inches = inches
        else { return }
        usernameLabel.text = username
        weightLabel.text = String(weight)
        feetLabel.text = String(feet)
        inchesLabel.text = String(inches)
    }

}//End of class
