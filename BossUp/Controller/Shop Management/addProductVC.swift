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
import Gallery

class addProductVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var capital: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let imagePickerController = ImagePickerController()
    let gallery = GalleryController()
    
    var imageList = [UIImage]()
    var galleryList = [Image]()
    
    override func viewDidLoad(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("addProductVC")
        self.actionSheet()
        self.price.placeholder = SharedInstance.currentCurrencyCode
        self.capital.placeholder = SharedInstance.currentCurrencyCode
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
    
    @IBAction func quantityType(_ sender: UISegmentedControl) {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            print("None")
        case 1:
            print("Clothes")
        case 2:
            print("Shoes")
        default:
            break
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
            self.openGallary()
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
        Config.tabsToShow = [.imageTab]
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
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
        
        if self.imageList.count > 1 {
            imagePickerController.showAlert(title: "Warning", message: "Please choose only 1 image")
        }else {
            imagePickerController.dismiss(animated: true, completion: nil)

        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension addProductVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        guard images.count > 0 else { return }
        
        self.galleryList = images.map {
            return $0
        }
        
        print(self.galleryList.count)
        
        if self.galleryList.count > 1 {
            gallery.showAlert(title: "Warning", message: "Please choose only 1 image")
        }else {
            gallery.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        gallery.dismiss(animated: true, completion: nil)
    }
}
