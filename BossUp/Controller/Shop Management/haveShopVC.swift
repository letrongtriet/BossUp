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
    
    var imageList = [UIImage]()
    var priceList = [String]()
    
    let userManager = BackendManager.shared.userReference
    let shopManager = BackendManager.shared.shopReference
    let imageManager = BackendManager.shared.imageReference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefresher()
        ARSLineProgress.showWithPresentCompetionBlock {
            self.updateList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("haveShopVC Will Appear")
    }
    
    fileprivate func updateList() {
        
        self.shopManager.child(SharedInstance.shopToLoad).child("product").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value else {return}
            let json = JSON(value)
            
            for (key,subJSON):(String, JSON) in json {
                SharedInstance.productList.append(key)
                self.priceList.append(subJSON["price"].stringValue)
            }
            print(SharedInstance.productList)
            print(self.priceList)
        }
        
        for product in SharedInstance.productList {
            self.imageManager.child(product).getData(maxSize: 1 * 1024 * 1024) { (data, err) in
                if let err = err {
                    self.showAlert(title: "Error", message: err.localizedDescription)
                } else {
                    let image = UIImage(data: data!)
                    self.imageList.append(image!)
                }
            }
        }
        
        ARSLineProgress.hideWithCompletionBlock {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
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
        return SharedInstance.productList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
