//
//  ViewController.swift
//  PHPhotoLibrary
//
//  Created by Hà Quang Hưng on 31/03/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil,
                                                    message: nil,
                                                preferredStyle: .actionSheet)
        if PermissionHelper().hasCameraPermission {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.openCamera()
            }
            alertController.addAction(cameraAction)
        }

        let photoLibraryAction
                = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openPhotoLibrary()
        }
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .fullScreen
        alertController.popoverPresentationController?.barButtonItem = sender
        present(alertController, animated: true)
    }
    
    private func openCamera() {
        PermissionHelper().requestCameraPermission(mediaType: .video) { granted, needOpenSetting in
            if granted {
                OperationQueue.main.addOperation {
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true)
                }
            }
        }
    }
    
    private func openPhotoLibrary() {
        PermissionHelper().requestPhotoPermission { granted, needOpenSetting in
            if granted {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true)
                }
            } else if needOpenSetting {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image.image = imagePicker
        }
        picker.dismiss(animated: true)
    }
}
