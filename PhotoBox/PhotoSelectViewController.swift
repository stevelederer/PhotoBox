//
//  PhotoSelectViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/24/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelected(photo: UIImage)
}

class PhotoSelectViewController: UIViewController {
    
    weak var delegate: PhotoSelectViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
//        selectImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectImage()
    }
    
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imagePickerActionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        imagePickerActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(imagePickerActionSheet, animated: true)
    }

}

extension PhotoSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.photoSelected(photo: photo)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
