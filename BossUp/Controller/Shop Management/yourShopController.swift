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

protocol FilterChangedDelegate: class {
    func updateData()
}

class yourShopController: UIViewController {
    
    fileprivate let userRef = BackendManager.shared.userReference
    fileprivate let shopRef = BackendManager.shared.shopReference
    
    weak var delegate: FilterChangedDelegate?
    
    @IBOutlet weak var menuButton: MyButton!
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
    
    let filterList = ["Shirts","Shoes","Pants","T-shirts","Bags","Clear filter"]
    
    var memberEmail:String = ""
    
    let dropDown = DropDown()
    let filterDropDown = DropDown()
    
    private lazy var haveShop: haveShopVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "haveShopVC") as! haveShopVC
        viewController.shopManagement = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillerButton.isHidden = true
        self.addMemberButton.isHidden = true
        self.addProductButton.isHidden = true
        self.filterLabel.isHidden = true
        
        self.menuButton.addedTouchArea = 60
        
        self.setUpDropDownButton()
        
        if ARSLineProgress.shown == false {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.setupView()
            }
        }else {
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
                case true:                    self.shopRef.child(Share.shopID).child("member").updateChildValues([Share.addMember:["member":self.memberEmail]])
                self.userRef.child(Share.addMember).child("shop").updateChildValues([Share.shopID:["shopName":Share.currentShopName,"type":"member"]])
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
}


// MARK: backend related
extension yourShopController {
    fileprivate func checkMember(completed: @escaping (_ success:Bool) -> Void) {
        self.userRef.observeSingleEvent(of: .value) { (res) in
            guard let value = res.value else {return}
            let json = JSON(value)
            
            for (key,subJson):(String, JSON) in json {
                if subJson["email"].stringValue == self.memberEmail {
                    Share.addMember = key
                    completed(true)
                }
            }
            completed(false)
        }
    }
    
    fileprivate func refreshUI() {
        if self.childViewControllers.isEmpty == false{
            let viewControllers:[UIViewController] = self.childViewControllers
            for viewContoller in viewControllers{
                viewContoller.willMove(toParentViewController: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParentViewController()
            }
        }
        self.setupView()
    }
    
    fileprivate func setupView() {
        userRef.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapShot) in
            if snapShot.hasChild("currentShop") {
                guard let value = snapShot.value else {return}
                let json = JSON(value)
                let currentShop = json["currentShop"].stringValue
                
                self.setUpFilterButton()
                
                self.addMemberButton.isHidden = false
                self.addProductButton.isHidden = false
                
                Share.shopID = currentShop
                
                for (key,subJSON):(String, JSON) in json["shop"] {
                    if self.shopList.contains(subJSON["shopName"].stringValue) == false {
                        self.shopList.insert(subJSON["shopName"].stringValue, at: 0)
                    }
                    
                    if key == currentShop {
                        Share.currentShopName = subJSON["shopName"].stringValue
                        if subJSON["type"].stringValue == "owner" {
                            Share.isOwner = true
                        }
                    }
                }
                
                self.shopButton.setTitle(Share.currentShopName, for: .normal)
                self.dropDown.dataSource = self.shopList
                self.add(asChildViewController: self.haveShop)
                
            }else {
                self.dropDown.dataSource = self.defaultList
                self.shopButton.setTitle("Create a Shop", for: .normal)
                self.add(asChildViewController: self.noShop)
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
                self?.userRef.child(Share.userID).child("shop").observeSingleEvent(of: .value, with: { (snapShot) in
                    guard let data = snapShot.value else {return}
                    let json = JSON(data)
                    for (key,subJSON):(String, JSON) in json {
                        if subJSON["shopName"].stringValue == item {
                            self?.userRef.child(Share.userID).child("currentShop").setValue(key)
                        }
                    }
                    self?.refreshUI()
                })
            }
        }
    }
    
    fileprivate func setUpFilterButton() {
        self.fillerButton.isHidden = false
        self.filterLabel.isHidden = false
        
        filterDropDown.anchorView = self.fillerButton
        filterDropDown.bottomOffset = CGPoint(x: 0, y: fillerButton.bounds.height)
        filterDropDown.dataSource = self.filterList
        // Action triggered on selection
        filterDropDown.selectionAction = { [weak self] (index, item) in
            if item != "Clear filter" {
                Share.filterOption = item
                self?.filterLabel.text = item
                self?.delegate?.updateData()
            }else {
                self?.filterLabel.text = "Filter"
                Share.filterOption = ""
                self?.delegate?.updateData()
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
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
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
        self.removeGesture()
        self.removeView()
    }
}



