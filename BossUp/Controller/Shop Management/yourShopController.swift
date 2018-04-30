//
//  yourShopController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import UserNotifications
import ARSLineProgress
import SwiftyJSON

class yourShopController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var fillerButton: UIButton!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var addMemberField: UITextField!
    
    @IBOutlet var addMemberView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    
    let defaultList = ["+ Create a shop"]
    
    var shopList = ["+ Create a shop"]
    
    let filterList = ["Clothes","Shoes","Pants","T-shirts","Bags","Clear filter"]
    
    var memberEmail:String = ""
    
    let dropDown = DropDown()
    let filterDropDown = DropDown()
    
    private lazy var haveShop: haveShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "haveShopVC") as! haveShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var noShop: noShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "noShopVC") as! noShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var createShop: createShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "createShopVC") as! createShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var noProduct: noProductVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "noProductVC") as! noProductVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillerButton.isHidden = true
        self.addMemberButton.isHidden = true
        self.addProductButton.isHidden = true
        
        self.setUpDropDownButton()
        
        ARSLineProgress.showWithPresentCompetionBlock {
            self.setupView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
        self.addMemberView.tag = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addShopDone), name: Notification.Name("addShop"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addProductDone), name: Notification.Name("addProduct"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentChosenProduct), name: Notification.Name("presentChosenProduct"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissChosenProduct), name: Notification.Name("dismissChosenProduct"), object: nil)
        
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressedShopButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    @IBAction func didPressFilterButton(_ sender: UIButton) {
        self.filterDropDown.show()
    }
    
    
    @IBAction func didPressAddProductButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "addProductVC") as! addProductVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddMemberButton(_ sender: UIButton) {
        self.addGesture()
        var darkBlur:UIBlurEffect = UIBlurEffect()
        darkBlur = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 2
        view.addSubview(blurView)
        
        addMemberView.center = self.view.center
        addMemberView.layer.shadowColor = UIColor.gray.cgColor
        addMemberView.layer.shadowOpacity = 1
        addMemberView.layer.shadowOffset = CGSize.zero
        addMemberView.layer.shadowRadius = 2
        self.view.addSubview(addMemberView)
    }
    
    
    @IBAction func addNewMember(_ sender: UIButton) {
        self.removeGesture()
        
        if self.addMemberField.text?.isEmpty == false {
            self.memberEmail = self.addMemberField.text!
            
            self.checkMember { (res) in
                switch res {
                case true:                    BackendManager.shared.shopReference.child(SharedInstance.shopID).child("member").updateChildValues([SharedInstance.addMember:["member":self.memberEmail]])
                BackendManager.shared.userReference.child(SharedInstance.addMember).child("shop").updateChildValues([SharedInstance.shopID:["shopName":SharedInstance.currentShopName,"type":"member"]])
                self.showAlert(title: "SUCCESS", message: "Member added")
                self.removeView()
                case false:
                    self.removeView()
                    self.showAlert(title: "Error", message: "Cannot find that user")
                }
            }
        }
    }
    
}


// MARK: action for call
extension yourShopController {
    @objc fileprivate func addShopDone() {
        ARSLineProgress.showWithPresentCompetionBlock {
            self.refreshUI()
        }
    }
    
    @objc fileprivate func addProductDone() {
        dismiss(animated: true) {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.refreshUI()
            }
        }
    }
    
    @objc fileprivate func presentChosenProduct() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "chosenProductVC") as! chosenProductVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissChosenProduct() {
        dismiss(animated: true) {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.refreshUI()
            }
        }
    }
}


// MARK: backend related
extension yourShopController {
    
    fileprivate func checkMember(completed: @escaping (_ success:Bool) -> Void) {
        BackendManager.shared.userReference.observeSingleEvent(of: .value) { (res) in
            guard let value = res.value else {return}
            
            let json = JSON(value)
            for (key,subJson):(String, JSON) in json {
                if subJson["email"].stringValue == self.memberEmail {
                    print("MATCHED")
                    SharedInstance.addMember = key
                    completed(true)
                }
            }
            print("Continue????")
            completed(false)
        }
    }
    
    fileprivate func refreshUI() {
        self.removeChildView()
        self.setupView()
    }
    
    fileprivate func setupView() {
        
        BackendManager.shared.userReference.child(SharedInstance.userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value else {return}
            let json = JSON(value)
            let currentShopName = json["currentShop"].stringValue
            
            if currentShopName == "" {
                self.dropDown.dataSource = self.defaultList
                self.shopButton.setTitle("Create a Shop", for: .normal)
                self.add(asChildViewController: self.noShop)
            }else {
                self.setUoFilterButton()
                
                self.addMemberButton.isHidden = false
                self.addProductButton.isHidden = false
                
                SharedInstance.currentShopName = currentShopName
                
                for (key,subJson):(String, JSON) in json["shop"] {
                    if self.shopList.contains(subJson["shopName"].stringValue) == false {
                        self.shopList.insert(subJson["shopName"].stringValue, at: 0)
                    }
                    if subJson["shopName"].stringValue == currentShopName {
                        SharedInstance.shopID = key
                    }
                }
                
                self.shopButton.setTitle(currentShopName, for: .normal)
                self.dropDown.dataSource = self.shopList
                
                BackendManager.shared.shopReference.child(SharedInstance.shopID).observeSingleEvent(of: .value, with: { (snap) in
                    guard let value = snap.value else {return}
                    let object = JSON(value)
                    
                    if object["product"].null != nil {
                        self.add(asChildViewController: self.noProduct)
                    }else {
                        for (key,_):(String, JSON) in object["product"] {
                            if SharedInstance.productList.contains(key) == false {
                                SharedInstance.productList.append(key)
                            }
                        }
                        self.add(asChildViewController: self.haveShop)
                    }
                })
                
                BackendManager.shared.shopReference.child(SharedInstance.shopID).observeSingleEvent(of: .value, with: { (snap) in
                    guard let data = snap.value else {return}
                    let json = JSON(data)
                    SharedInstance.currentCurrencyCode = json["currentCurrencyCode"].stringValue
                })
                
                BackendManager.shared.shopReference.child(SharedInstance.shopID).child("member").observeSingleEvent(of: .value) { (data) in
                    guard let value = data.value else {return}
                    let json = JSON(value)
                    
                    for (_,sub):(String,JSON) in json {
                        if sub["owner"].null == nil {
                            if sub["owner"].stringValue == SharedInstance.userEmail {
                                SharedInstance.isOwner = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func setUpDropDownButton() {
        
        dropDown.anchorView = self.shopButton
        dropDown.bottomOffset = CGPoint(x: 0, y: shopButton.bounds.height)

        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            
            if item == "+ Create a shop" {
                self?.add(asChildViewController: (self?.createShop)!)
            }else {
                SharedInstance.productList = []
                BackendManager.shared.userReference.child(SharedInstance.userID).child("currentShop").setValue(item)
                
                ARSLineProgress.showWithPresentCompetionBlock {
                    self?.refreshUI()
                }
            }
        }
    }
    
    fileprivate func setUoFilterButton() {
        
        self.fillerButton.isHidden = false
        filterDropDown.anchorView = self.fillerButton
        filterDropDown.bottomOffset = CGPoint(x: 0, y: fillerButton.bounds.height)
        
        filterDropDown.dataSource = self.filterList
        
        // Action triggered on selection
        filterDropDown.selectionAction = { [weak self] (index, item) in
            
            if item != "Clear filter" {
                print("Not clear filter")
                SharedInstance.filterOption = item
                self?.filterLabel.text = item
                self?.refreshUI()
            }else {
                print("Clear filter")
                self?.filterLabel.text = "Filter"
                SharedInstance.filterOption = ""
                self?.refreshUI()
            }
            
        }
    }
}


// MARK: add and remove views
extension yourShopController {
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.lightGray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
        
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
    }
    
    fileprivate func removeChildView() {
        if self.childViewControllers.count > 0{
            let viewControllers:[UIViewController] = self.childViewControllers
            for viewContoller in viewControllers{
                viewContoller.willMove(toParentViewController: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParentViewController()
            }
        }
    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    fileprivate func removeView() {
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    fileprivate func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    fileprivate func removeGesture() {
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
    }
    
    @objc fileprivate func handleTap() {
        print("Add member dismissed")
        self.removeGesture()
        self.removeView()
    }
}



