//
//  haveShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import ARSLineProgress

class haveShopVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refresher:UIRefreshControl!
    
    let userManager = BackendManager.shared.userReference
    let shopManager = BackendManager.shared.shopReference
    let imageManager = BackendManager.shared.imageReference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefresher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharedInstance.productList = []
        self.getData()
    }
    
    fileprivate func getData() {
        self.shopManager.child(SharedInstance.shopID).observeSingleEvent(of: .value, with: { (snap) in
            guard let value = snap.value else {return}
            let object = JSON(value)
            
            for (key,sub):(String, JSON) in object["product"] {
                
                if SharedInstance.filterOption == "" {
                    if SharedInstance.productList.contains(key) == false {
                        SharedInstance.productList.append(key)
                    }
                }else {
                    if SharedInstance.productList.contains(key) == false && sub["category"].stringValue == SharedInstance.filterOption {
                        SharedInstance.productList.append(key)
                    }
                }
                
            }
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            
            if ARSLineProgress.shown == true {
                ARSLineProgress.hide()
            }
        })
    }
}

extension haveShopVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize/2
        let height = collectionView.frame.size.height / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SharedInstance.productList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.productCurrency.text = SharedInstance.currentCurrencyCode
        
        self.shopManager.child(SharedInstance.shopID).child("product").child(SharedInstance.productList[indexPath.row]).observeSingleEvent(of: .value) { (snap) in
            
            guard let value = snap.value else {return}
            let json = JSON(value)
            cell.productName.text = json["name"].stringValue
            cell.productPrice.text = json["price"].stringValue
        }
        
        self.imageManager.child(SharedInstance.productList[indexPath.row]).getData(maxSize: 1 * 1024 * 1024) { (data, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                let image = UIImage(data: data!)
                cell.productImage.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SharedInstance.chosenProduct = SharedInstance.productList[indexPath.row]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("presentChosenProduct"), object: nil)
        }
    }
    
}

// MARK: supporting functions
extension haveShopVC {
    fileprivate func addRefresher() {
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.black
        self.refresher.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
    }
    
    @objc fileprivate func loadData() {
        self.getData()
        self.refresher.endRefreshing()
    }
}
