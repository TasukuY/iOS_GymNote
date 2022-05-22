//
//  UserImageSetupViewController.swift
//  GymNote
//
//  Created by Tasuku Yamamoto on 5/14/22.
//

import UIKit
import MobileCoreServices

class UserImageSetupViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    
    //MARK: - Properties
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
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    //MARK: - Helper Methods
    func setupView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.label.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
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
            let profileImage = profileImage ?? UIImage(systemName: UserConstants.defaultProfileImage)
            
            destination.username = username
            destination.weight = weight
            destination.height = height
            destination.feet = feet
            destination.inches = inches
            destination.profileImage = profileImage
        }
    }
    
}//End of class

extension UserImageSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        profileImage = selectedImage

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}//End of extension
