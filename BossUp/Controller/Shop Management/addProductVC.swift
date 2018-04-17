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
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var clotheView: UIView!
    @IBOutlet weak var shoeView: UIView!
    @IBOutlet weak var noneView: UIView!
    
    let imagePickerController = ImagePickerController()
    let gallery = GalleryController()
    
    var imageList = [UIImage]()
    var galleryList = [Image]()
    
    override func viewDidLoad(){
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.price.placeholder = SharedInstance.currentCurrencyCode
        self.capital.placeholder = SharedInstance.currentCurrencyCode
        
        self.clotheView.tag = 222
        self.noneView.tag = 111
        self.shoeView.tag = 333
        
        self.gestureForImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("addProductVC")
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
            self.removeView()
            self.addSubView(view: self.noneView)
        case 1:
            print("Clothes")
            self.removeView()
            self.addSubView(view: self.clotheView)
        case 2:
            print("Shoes")
            self.removeView()
            self.addSubView(view: self.shoeView)
        default:
            print("Default")
            self.removeView()
            self.addSubView(view: self.clotheView)
        }
    }
    
}

extension addProductVC {
    
    @objc fileprivate func actionSheet() {
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
    
    fileprivate func gestureForImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.actionSheet))
        self.productImage.isUserInteractionEnabled = true
        self.productImage.addGestureRecognizer(tap)
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
    
    fileprivate func addSubView(view: UIView) {
        view.center = self.quantityView.center
        view.frame = self.quantityView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.quantityView.addSubview(view)
    }
    
    fileprivate func removeView() {
        if let viewWithTag = self.quantityView.viewWithTag(111) {
            viewWithTag.removeFromSuperview()
            print("Remove none")
        }
        
        if let viewWithTag = self.quantityView.viewWithTag(222) {
            viewWithTag.removeFromSuperview()
            print("Remove clothes")
        }
        
        if let viewWithTag = self.quantityView.viewWithTag(333) {
            viewWithTag.removeFromSuperview()
            print("Remove shoes")
        }
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
            self.productImage.image = imageList.first
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
            Image.resolve(images: self.galleryList) { (temp) in
                self.productImage.image = temp.first as? UIImage
                self.gallery.dismiss(animated: true, completion: nil)
            }
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
