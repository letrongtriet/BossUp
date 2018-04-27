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
import FirebaseStorage
import ARSLineProgress
import SwiftyJSON

class addProductVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var category: UIButton!
    
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var capital: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nameOfCategory: UITextField!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var clotheView: UIView!
    @IBOutlet weak var shoeView: UIView!
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var chooseCategoryView: UIView!
    @IBOutlet weak var newCategoryView: UIView!
    
    @IBOutlet weak var xxs: UITextField!
    @IBOutlet weak var xs: UITextField!
    @IBOutlet weak var s: UITextField!
    @IBOutlet weak var m: UITextField!
    @IBOutlet weak var l: UITextField!
    @IBOutlet weak var xl: UITextField!
    @IBOutlet weak var xxl: UITextField!
    @IBOutlet weak var xxxl: UITextField!
    
    @IBOutlet weak var shoe35: UITextField!
    @IBOutlet weak var shoe36: UITextField!
    @IBOutlet weak var shoe37: UITextField!
    @IBOutlet weak var shoe38: UITextField!
    @IBOutlet weak var shoe39: UITextField!
    @IBOutlet weak var shoe40: UITextField!
    @IBOutlet weak var shoe41: UITextField!
    @IBOutlet weak var shoe42: UITextField!
    @IBOutlet weak var shoe43: UITextField!
    @IBOutlet weak var shoe44: UITextField!
    
    @IBOutlet weak var none: UITextField!
    
    let imagePickerController = ImagePickerController()
    let gallery = GalleryController()
    
    var imageList = [UIImage]()
    var galleryList = [Image]()
    
    var clotheList = [UITextField]()
    let clotheNames = ["2XS","XS","S","M","L","XL","2XL","3XL"]
    
    var shoeList = [UITextField]()
    let shoeNames = ["35","36","37","38","39","40","41","42","43","44"]
    
    var noneList = [UITextField]()
    let noneNames = ["None"]
    
    var key = String()
    
    var sizeType = String()
    
    let defaultImage = #imageLiteral(resourceName: "photo_default")
    
    override func viewDidLoad(){
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.price.placeholder = SharedInstance.currentCurrencyCode
        self.capital.placeholder = SharedInstance.currentCurrencyCode
        
        self.clotheView.tag = 222
        self.noneView.tag = 111
        self.shoeView.tag = 333
        self.chooseCategoryView.tag = 444
        self.newCategoryView.tag = 555
        
        self.clotheList = [xxs,xs,s,m,l,xl,xxl,xxl]
        self.shoeList = [shoe35,shoe36,shoe37,shoe38,shoe39,shoe40,shoe41,shoe42,shoe43,shoe44]
        self.noneList = [none]
        
        self.addSubView(view: self.quantityView, subView: self.clotheView)
        
        self.gestureForImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SharedInstance.chosenProductEdit != "" {
            print("It is edit product")
            self.fillInformation()
        }else {
            print("It is not edit product! It is add new product")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("addProductVC")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SharedInstance.chosenProductEdit = ""
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        print("Cancel button pressed")
        if SharedInstance.chosenProductEdit != "" {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("dismissAddProductFromChosen"), object: nil)
            }
        }else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("addProduct"), object: nil)
            }
        }
    }
    
    @IBAction func didPressAdd(_ sender: UIButton) {
        print("Add button pressed")
        
        if SharedInstance.chosenProductEdit != "" {
            self.key = SharedInstance.chosenProductEdit
        }else {
            self.key = BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").childByAutoId().key
        }
        
        ARSLineProgress.showWithPresentCompetionBlock {
            self.uploadProduct()
        }
    }
    
    @IBAction func quantityType(_ sender: UISegmentedControl) {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            print("None")
            self.removeView()
            self.addSubView(view: self.quantityView, subView: self.noneView)
            self.sizeType = "none"
        case 1:
            print("Clothes")
            self.removeView()
            self.addSubView(view: self.quantityView, subView: self.clotheView)
            self.sizeType = "clothes"
        case 2:
            print("Shoes")
            self.removeView()
            self.addSubView(view: self.quantityView, subView: self.shoeView)
            self.sizeType = "shoes"
        default:
            print("Default")
            self.removeView()
            self.addSubView(view: self.quantityView, subView: self.clotheView)
            self.sizeType = "clothes"
        }
    }
    
    @IBAction func categoryButton(_ sender: UIButton) {
        self.addSubView(view: self.view, subView: self.chooseCategoryView)
    }
    
    @IBAction func shoeButton(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
            self.category.setTitle("Shoes", for: .normal)
        }
    }
    
    @IBAction func tshirtButton(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
            self.category.setTitle("T-Shirt", for: .normal)
        }
    }
    
    @IBAction func shirtButton(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
            self.category.setTitle("Shirt", for: .normal)
        }
    }
    
    @IBAction func pantButton(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
            self.category.setTitle("Pants", for: .normal)
        }
    }
    
    @IBAction func bagButton(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
            self.category.setTitle("Bag", for: .normal)
        }
    }
    
    @IBAction func addCategoryButton(_ sender: UIButton) {
        self.gestureForNewCategoryView()
        var darkBlur:UIBlurEffect = UIBlurEffect()
        darkBlur = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.chooseCategoryView.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 666
        self.chooseCategoryView.addSubview(blurView)
        
        self.newCategoryView.center = self.chooseCategoryView.center
        self.chooseCategoryView.addSubview(self.newCategoryView)
    }
    
    @IBAction func addNewCategory(_ sender: UIButton) {
        if self.nameOfCategory.text?.isEmpty == false {
            if let viewWithTag = self.chooseCategoryView.viewWithTag(555) {
                
                viewWithTag.removeFromSuperview()
                
                if let viewWithTag3 = self.chooseCategoryView.viewWithTag(666) {
                    viewWithTag3.removeFromSuperview()
                }
                
                if let viewWithTag2 = self.view.viewWithTag(444) {
                    viewWithTag2.removeFromSuperview()
                    self.category.setTitle(self.nameOfCategory.text!, for: .normal)
                }
            }
        }else {
            self.showAlert(title: "Warning", message: "Please enter the name of new category")
        }
    }
    
    @IBAction func cancelButtonChooseCategory(_ sender: UIButton) {
        if let viewWithTag = self.view.viewWithTag(444) {
            viewWithTag.removeFromSuperview()
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
    
    @objc fileprivate func removeNewCategoryView() {
        print("Add New Category View dimissed")
        if let viewWithTag = self.chooseCategoryView.viewWithTag(555) {
            
            viewWithTag.removeFromSuperview()
            
            if let viewWithTag3 = self.chooseCategoryView.viewWithTag(666) {
                viewWithTag3.removeFromSuperview()
            }
        }
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
    }
    
    fileprivate func gestureForImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.actionSheet))
        self.productImage.isUserInteractionEnabled = true
        self.productImage.addGestureRecognizer(tap)
    }
    
    fileprivate func gestureForNewCategoryView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeNewCategoryView))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
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
    
    fileprivate func addSubView(view: UIView,subView: UIView) {
        subView.center = view.center
        subView.frame = view.bounds
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(subView)
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

extension addProductVC {
    
    fileprivate func addProductToBackend(name:String, price:String, capital:String, category:String, sizeType:String) {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("name").setValue(name)
        
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("price").setValue(price)
        
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("capital").setValue(capital)
        
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("category").setValue(category)
        
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("sizeType").setValue(sizeType)
    }
    
    fileprivate func uploadProduct() {
        
        if self.productImage.image == self.defaultImage || self.name.text?.isEmpty == true || self.price.text?.isEmpty == true || self.category.currentTitle == "Click to choose" {
            
            ARSLineProgress.hideWithCompletionBlock {
                self.showAlert(title: "Warning", message: "Please fill in all required field and image")
            }
            
        }else {
            if let uploadData = UIImageJPEGRepresentation(self.productImage.image!, 0.3) {
                print("Image is ok for uploading")
                
                let newMetadata = StorageMetadata()
                newMetadata.contentType = "image/jpeg"
                
                BackendManager.shared.imageReference.child(self.key).putData(uploadData, metadata: newMetadata)
                
                if self.capital.text?.isEmpty == false {
                    self.addProductToBackend(name: self.name.text!, price: self.price.text!, capital: self.capital.text!, category: self.category.currentTitle!, sizeType: self.sizeType)
                }else {
                    self.addProductToBackend(name: self.name.text!, price: self.price.text!, capital: "0", category: self.category.currentTitle!, sizeType: self.sizeType)
                }
                
                self.addQuantity()
            }else {
                ARSLineProgress.hideWithCompletionBlock {
                    self.showAlert(title: "Error", message: "Image cannot be uploaded. Please try again later")
                }
            }
        }
    }
    
    fileprivate func addQuantity() {
        
        var currentList = [UITextField]()
        var currentName = [String]()
        
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            print("None")
            currentList = self.noneList
            currentName = self.noneNames
        case 1:
            print("Clothes")
            currentList = self.clotheList
            currentName = self.clotheNames
        case 2:
            print("Shoes")
            currentList = self.shoeList
            currentName = self.shoeNames
        default:
            print("Default")
            currentList = self.clotheList
            currentName = self.clotheNames
        }
        
        for i in 0...currentList.count-1 {
            if currentList[i].text?.isEmpty == false {
                BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("quantity").childByAutoId().setValue(["quantity":currentList[i].text!,"size":currentName[i]])
                
                _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addProducDone), userInfo: nil, repeats: false)
            }else {
                BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(self.key).child("quantity").childByAutoId().setValue(["quantity":"0","size":currentName[i]])
                
                _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addProducDone), userInfo: nil, repeats: false)
            }
        }
        
    }
    
    @objc fileprivate func addProducDone() {
        ARSLineProgress.hideWithCompletionBlock {
            if SharedInstance.chosenProductEdit != "" {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("dismissAddProductFromChosen"), object: nil)
                }
            }else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("addProduct"), object: nil)
                }
            }
        }
    }
    
    fileprivate func fillInformation() {
       self.productImage.image = SharedInstance.chosenProductImage
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(SharedInstance.chosenProductEdit).observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            self.name.text = json["name"].stringValue
            self.price.text = json["price"].stringValue
            self.capital.text = json["capital"].stringValue
            self.category.setTitle(json["category"].stringValue, for: .normal)
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
