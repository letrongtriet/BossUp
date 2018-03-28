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

class yourShopController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let defaultList = ["Create a shop","Find a shop"]
    
    var shopList = ["Admin's Shop"]
    
    let dropDown = DropDown()
    
    private lazy var haveShopVC: haveShopVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "haveShopVC") as! haveShopVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var noShopVC: noShopVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "noShopVC") as! noShopVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var createShopVC: createShopVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "createShopVC") as! createShopVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressedShopButton(_ sender: UIButton) {
        self.dropDown.show()
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
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            BackendManager.shared.userReference.child(currentUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let value = snapshot.value else {return}
                
                guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                print(data)
                guard let user = try? JSONDecoder().decode(User.self, from: data) else {return}
                print(user)
                
                if user.currentShop == "" {
                    self.dropDown.dataSource = self.defaultList
                    self.shopButton.setTitle("Create a Shop", for: .normal)
                    self.add(asChildViewController: self.noShopVC)
                }else {
                    print("Found a list")
                    self.shopButton.setTitle("Admin's Shop", for: .normal)
                    self.dropDown.dataSource = self.shopList
                    self.add(asChildViewController: self.haveShopVC)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.shopButton.setTitle(item, for: .normal)
            
            if index == 0 {
                self?.remove(asChildViewController: (self?.noShopVC)!)
                self?.add(asChildViewController: (self?.createShopVC)!)
            }
        }

    }
    
    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}



