//
//  haveShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress
import SwiftyJSON

class haveShopVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refresher:UIRefreshControl!
    
    var productList: [String]?
    
    let userManager = BackendManager.shared.userReference
    let shopManager = BackendManager.shared.shopReference
    let imageManager = BackendManager.shared.imageReference

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefresher()
        
        print("haveShopVC")
        
        self.updateList()
        ARSLineProgress.showWithPresentCompetionBlock {
            self.updateList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("haveShopVC Will Appear")
    }
    
    fileprivate func updateList() {
        ARSLineProgress.showWithPresentCompetionBlock {
            if let user = Auth.auth().currentUser {
                let id = user.uid
                self.userManager.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let value = snapshot.value else {return}
                    
                    guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                    guard let user = try? JSONDecoder().decode(User.self, from: data) else {return}
                    print(user)
                    
                    if let currentShopID = user.currentShop {
                        self.shopManager.child(currentShopID).child("product").observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let value = snapshot.value else {return}
                            
                            let json = JSON(value)
                            
                            for (key,subJson):(String, JSON) in json {
                                print(key,subJson)
                            }
                            
                        }, withCancel: { (error) in
                            ARSLineProgress.hide()
                            print(error.localizedDescription)
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        })
                    }
                    
                }) { (error) in
                    ARSLineProgress.hide()
                    print(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                
            }else {
                ARSLineProgress.hide()
                self.showAlert(title: "Error", message: "Cannot find user")
            }
        }
    }
    
}

extension haveShopVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        return cell
    }
    
}

// MARK: supporting functions
extension haveShopVC {
    fileprivate func addRefresher() {
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    @objc fileprivate func loadData() {
        self.updateList()
        stopRefresher()
    }
    
    fileprivate func stopRefresher() {
        self.refresher.endRefreshing()
    }
}
