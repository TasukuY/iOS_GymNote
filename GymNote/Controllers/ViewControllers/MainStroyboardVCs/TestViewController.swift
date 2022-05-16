//
//  TestViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/13/22.
//

import UIKit

class TestViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var feetLabel: UILabel!
    @IBOutlet weak var inchesLabel: UILabel!
    
    //MARK: - Properties
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    
    //MARK: - Helper Methods
    func setupView() {
        guard let user = UserController.shared.user
        else { return }
        let height = String(user.height)
        let feet = height.split(separator: ".")[0]
        let inches = height.split(separator: ".")[1]
        usernameLabel.text = user.username
        weightLabel.text = String(user.weight)
        feetLabel.text = String(feet)
        inchesLabel.text = String(inches)
    }

}//End of class
