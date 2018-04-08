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
    
    let defaultList = ["+ Create a shop"]
    
    var shopList = ["+ Create a shop"]
    
    var currentState = ""
        
    let dropDown = DropDown()
    
    private lazy var haveShopVC: haveShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "haveShopVC") as! haveShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var noShopVC: noShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "noShopVC") as! noShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var createShopVC: createShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "createShopVC") as! createShopVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var addProductVC: addProductVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProductVC") as! addProductVC
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var noProductVC: noProductVC = {
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
        
        ARSLineProgress.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressedShopButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    @IBAction func didPressAddProductButton(_ sender: UIButton) {
        switch currentState {
        case "haveShopVC":
            self.remove(asChildViewController: haveShopVC)
            self.add(asChildViewController: addProductVC)
        case "noProductVC":
            self.remove(asChildViewController: noProductVC)
            self.add(asChildViewController: addProductVC)
        default:
            self.remove(asChildViewController: haveShopVC)
            self.add(asChildViewController: addProductVC)
        }
    }
    
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.gray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
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
                    self.add(asChildViewController: self.noShopVC)
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
                    
                    self.shopButton.setTitle(currentShopID, for: .normal)
                    self.dropDown.dataSource = self.shopList
                    
                    BackendManager.shared.shopReference.child(SharedInstance.shopToLoad).observeSingleEvent(of: .value, with: { (snap) in
                        guard let value = snap.value else {return}
                        
                        let object = JSON(value)
                        print("Getting product")
                        print(object)
                        if object["product"].null != nil {
                            self.currentState = "noProductVC"
                            self.add(asChildViewController: self.noProductVC)
                            ARSLineProgress.hide()
                        }else {
                            self.currentState = "haveShopVC"
                            self.add(asChildViewController: self.haveShopVC)
                            ARSLineProgress.hide()
                        }
                    })
                    
                    
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.shopButton.setTitle(item, for: .normal)
            
            if item == "+ Create a shop" {
                self?.remove(asChildViewController: (self?.noShopVC)!)
                self?.add(asChildViewController: (self?.createShopVC)!)
                NotificationCenter.default.addObserver(self!, selector: #selector(self?.shopCreated), name: Notification.Name("shopCreated"), object: nil)
                NotificationCenter.default.addObserver(self!, selector: #selector(self?.shopCanceled), name: Notification.Name("shopCanceled"), object: nil)
            }
        }

    }
}

extension yourShopController {
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
    
    @objc fileprivate func shopCreated() {
        ARSLineProgress.showWithPresentCompetionBlock {
            self.shopList = []
            self.remove(asChildViewController: (self.createShopVC))
            self.add(asChildViewController: (self.noProductVC))
            self.resetUI()
        }
    }
    
    @objc fileprivate func shopCanceled() {
        switch currentState {
        case "haveShopVC":
            self.remove(asChildViewController: createShopVC)
            self.add(asChildViewController: haveShopVC)
        case "noProductVC":
            self.remove(asChildViewController: createShopVC)
            self.add(asChildViewController: noProductVC)
        default:
            self.remove(asChildViewController: createShopVC)
            self.add(asChildViewController: haveShopVC)
        }
    }
}

extension yourShopController {
    fileprivate func resetUI() {
        BackendManager.shared.userReference.child(SharedInstance.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else {return}
            let json = JSON(value)
            let currentShopID = json["currentShop"].stringValue
            
            SharedInstance.currentShopID = currentShopID
            
            for (_,subJson):(String, JSON) in json["shop"] {
                print(subJson)
                self.shopList.insert(subJson["shopName"].stringValue, at: 0)
            }
            
            self.shopButton.setTitle(currentShopID, for: .normal)
            self.dropDown.dataSource = self.shopList
            ARSLineProgress.hide()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}


