//
//  SettingView+PhotoPicker.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 08/12/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit

extension SettingView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func openImageSelector(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: GusSetLanguage.getLanguage(key: "setting.menu.changePhoto"), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: GusSetLanguage.getLanguage(key: "global.camera.choose"), style: UIAlertAction.Style.default) {
            _ in
            self.openCameraPhone()
        }
        let gallaryAction = UIAlertAction(title: GusSetLanguage.getLanguage(key: "global.gallery.choose"), style: UIAlertAction.Style.default) {
            _ in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: GusSetLanguage.getLanguage(key: "global.string.cancel"), style: UIAlertAction.Style.cancel) {
            _ in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCameraPhone() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.alertMessage("", message: "Your device has no camera") {
                
            }
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - PickerView Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imageAvatarUser = image
            self.getPhoto = image
            self.tableView.reloadData()
        } else {
            print("Not able to get an image")
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

