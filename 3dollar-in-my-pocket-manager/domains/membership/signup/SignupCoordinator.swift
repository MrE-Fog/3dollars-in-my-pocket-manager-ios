import UIKit
import PhotosUI

import SPPermissions
import SPPermissionsPhotoLibrary
import SPPermissionsCamera

protocol SignupCoordinator: BaseCoordinator, AnyObject {
    func showPhotoActionSheet()
    
    func showCamera()
    
    func showAlbumPicker()
}

extension SignupCoordinator where Self: BaseViewController {
    func showPhotoActionSheet() {
        let alert = UIAlertController(
            title: "이미지 불러오기",
            message: nil,
            preferredStyle: .actionSheet
        )
        let libraryAction = UIAlertAction(
            title: "앨범",
            style: .default
        ) { _ in
            if SPPermissions.Permission.photoLibrary.authorized {
                self.showAlbumPicker()
            } else {
                let controller = SPPermissions.native([.photoLibrary])
                
                controller.delegate = self as? SPPermissionsDelegate
                controller.present(on: self)
            }
        }
        let cameraAction = UIAlertAction(
            title: "카메라",
            style: .default
        ) { _ in
            if SPPermissions.Permission.camera.authorized {
                self.showCamera()
            } else {
                let controller = SPPermissions.native([.camera])
                
                controller.delegate = self as? SPPermissionsDelegate
                controller.present(on: self)
            }
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.presenter.present(alert, animated: true)
    }
    
    func showCamera() {
        let imagePicker = UIImagePickerController().then {
            $0.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            $0.sourceType = .camera
            $0.cameraCaptureMode = .photo
        }
        
        self.presenter.present(imagePicker, animated: true)
    }
    
    func showAlbumPicker() {
        var configuration = PHPickerConfiguration()
        
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self as? PHPickerViewControllerDelegate
        self.presenter.present(picker, animated: true, completion: nil)
    }
}
