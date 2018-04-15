//
//  addProductVC.swift
//  BossUp
//
//  Created by Triet Le on 05/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox

class addProductVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    let imagePickerController = ImagePickerController()
    
    var imageList = [UIImage]()
    
    override func viewDidLoad(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("addProductVC")
        self.actionSheet()
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        print("Cancel button pressed")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("productCanceled"), object: nil)
        }
    }
    
    @IBAction func didPressAdd(_ sender: UIButton) {
        print("Add button pressed")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("productCreated"), object: nil)
        }
    }
    
}

extension addProductVC {
    
    fileprivate func actionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let creditCardsAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Camera")
            self.openCamera()
        })
        
        let otherAction = UIAlertAction(title: "Gallary", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Gallary")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(creditCardsAction)
        optionMenu.addAction(otherAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true) {
            print("Option presented")
        }
    }
    
    fileprivate func openCamera() {
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func openGallary() {
        
    }
}

extension addProductVC: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        guard images.count > 0 else { return }
        
        self.imageList = images.map {
            return $0
        }
        
        print(self.imageList.count)
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
