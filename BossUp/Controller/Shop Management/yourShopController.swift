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
    
    let defaultList = ["+ Create a shop"]
    
    var shopList = ["+ Create a shop"]
    
    var memberEmail:String = ""
    
    let dropDown = DropDown()
    
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
        
        self.setupView()
        self.addGesture()
        
        ARSLineProgress.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
        self.addMemberView.tag = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.shopCreated), name: Notification.Name("shopCreated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.shopCanceled), name: Notification.Name("shopCanceled"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.productCreated), name: Notification.Name("productCreated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.productCanceled), name: Notification.Name("productCanceled"), object: nil)
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressedShopButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    @IBAction func didPressAddProductButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "addProductVC") as! addProductVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddMemberButton(_ sender: UIButton) {
        
        var darkBlur:UIBlurEffect = UIBlurEffect()
        
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.prominent)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
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
        
        if self.addMemberField.text?.isEmpty == false {
            self.memberEmail = self.addMemberField.text!
            
            self.checkMember { (res) in
                switch res {
                case true:
                    print("Key: \(SharedInstance.addMember)")
                    BackendManager.shared.shopReference.child(SharedInstance.shopToLoad).child("member").updateChildValues([SharedInstance.addMember:["member":self.memberEmail]])
                    
                    BackendManager.shared.userReference.child(SharedInstance.addMember).child("shop").updateChildValues([SharedInstance.shopToLoad:["shopName":SharedInstance.currentShopID,"type":"member"]])
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
    
    @objc fileprivate func shopCreated() {
        ARSLineProgress.showWithPresentCompetionBlock {
            self.shopList = []
            self.setupView()
        }
    }
    
    @objc fileprivate func shopCanceled() {
        ARSLineProgress.showWithPresentCompetionBlock {
            self.shopList = []
            self.setupView()
        }
    }
    
    @objc fileprivate func productCreated() {
        dismiss(animated: true) {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.shopList = []
                self.setupView()
            }
        }
    }
    
    @objc fileprivate func productCanceled() {
        dismiss(animated: true) {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.shopList = []
                self.setupView()
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
    
    fileprivate func setupView() {
        
        dropDown.anchorView = self.shopButton
        dropDown.bottomOffset = CGPoint(x: 0, y: shopButton.bounds.height)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        
        BackendManager.shared.userReference.child(SharedInstance.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value else {return}
            let json = JSON(value)
            let currentShopID = json["currentShop"].stringValue
            
            if currentShopID == "" {
                self.dropDown.dataSource = self.defaultList
                self.shopButton.setTitle("Create a Shop", for: .normal)
                SharedInstance.currentState = "noShopVC"
                self.add(asChildViewController: self.noShop)
                ARSLineProgress.hide()
            }else {
                
                self.fillerButton.isHidden = false
                self.addMemberButton.isHidden = false
                self.addProductButton.isHidden = false
                
                SharedInstance.currentShopID = currentShopID
                
                for (key,subJson):(String, JSON) in json["shop"] {
                    self.shopList.insert(subJson["shopName"].stringValue, at: 0)
                    if subJson["shopName"].stringValue == currentShopID {
                        SharedInstance.shopToLoad = key
                    }
                }
                
                print("Shop To Load: \(SharedInstance.shopToLoad)")
                
                self.shopButton.setTitle(currentShopID, for: .normal)
                self.dropDown.dataSource = self.shopList
                
                BackendManager.shared.shopReference.child(SharedInstance.shopToLoad).observeSingleEvent(of: .value, with: { (snap) in
                    guard let value = snap.value else {return}
                    
                    let object = JSON(value)
                    print("Getting product")
                    print(object)
                    if object["product"].null != nil {
                        SharedInstance.currentState = "noProductVC"
                        self.add(asChildViewController: self.noProduct)
                        ARSLineProgress.hide()
                    }else {
                        SharedInstance.currentState = "haveShopVC"
                        self.add(asChildViewController: self.haveShop)
                        ARSLineProgress.hide()
                    }
                })
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            
            if item == "+ Create a shop" {
                self?.remove(asChildViewController: (self?.noShop)!)
                self?.add(asChildViewController: (self?.createShop)!)
            }
        }
        
    }
}


// MARK: add and remove views
extension yourShopController {
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.gray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
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
    
    @objc fileprivate func handleTap() {
        print("Add member dismissed")
        self.removeView()
    }
}



