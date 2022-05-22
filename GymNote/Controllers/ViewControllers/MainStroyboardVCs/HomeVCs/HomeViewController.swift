//
//  HomeViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/22/22.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var workoutCalender: UIDatePicker!
    @IBOutlet weak var profileImageButton: UIButton!
    
    //MARK: - Properties
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBActions
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    //MARK: - Helper Methods
    func setupView() {
        setupProfileImageView()
    }
    
    func setupProfileImageView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
    }
    
    func setupUsernameLabel() {
        usernameLabel.numberOfLines = 0
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}//End of class

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Image",
                                            message: "How would you like to select an image?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func presentPhotoPicker() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

        profileImageView.image = selectedImage

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}//End of extension
