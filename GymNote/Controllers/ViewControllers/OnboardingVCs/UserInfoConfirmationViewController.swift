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
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: - Properties
    private let storyboardManager = StoryboardManager()
    var username: String?
    var weight: Double?
    var height: Double?
    var feet: Int?
    var inches: Int?
    var profileImage: UIImage?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func doneSetupButtonTapped(_ sender: Any) {
        setupUserInfo()
        if UserController.shared.user != nil {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: StoryboardConstants.isOnboardedKey)
                self.storyboardManager.instantiateWorkoutSetupStoryboard()
            }
        } else {
            DispatchQueue.main.async {
                AlertManager.showUserSetupError(on: self)                
            }
        }
    }
    
    //MARK: - Helper Methods
    func setupUserInfo() {
        guard let username = username,
              let weight = weight,
              let height = height,
              let profileImage = profileImage
        else { return }
        UserController.shared.saveUserInfoWith(username: username, weight: weight, height: height, prifileImage: profileImage)
    }
    
    func setupView() {
        guard let username = username,
              let weight = weight,
              let feet = feet,
              let inches = inches,
              let profileImage = profileImage
        else { return }
        DispatchQueue.main.async {
            self.usernameLabel.text = username
            self.weightLabel.text = String(weight)
            self.feetLabel.text = String(feet)
            self.inchesLabel.text = String(inches)
            self.profileImageView.image = profileImage
            self.setupProfileImageView()
        }
    }
    
    func setupProfileImageView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
    }

}//End of class
