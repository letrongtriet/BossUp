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

class haveShopVC: UIViewController, FilterChangedDelegate {
    
    var shopManagement: yourShopController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var noProductView: UIView!
    
    var refresher:UIRefreshControl!
    
    let userRef = BackendManager.shared.userReference
    let shopRef = BackendManager.shared.shopReference
    let imageRef = BackendManager.shared.imageReference
    
    fileprivate var names = [String]()
    fileprivate var prices = [String]()
    fileprivate var imageKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefresher()
        self.shopManagement?.delegate = self
        print("Viewdidload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func updateData() {
        self.reloadData()
    }
}

extension haveShopVC {
    fileprivate func reloadData() {
        self.names = []
        self.prices = []
        self.imageKeys = []
        self.getData()
    }
    
    fileprivate func getData() {
        print("Getting data")
        
        self.shopRef.child(Share.shopID).observeSingleEvent(of: .value, with: { (snap) in
            guard let data = snap.value else {return}
            let json = JSON(data)
            Share.currentCurrencyCode = json["currentCurrencyCode"].stringValue
            print(Share.currentCurrencyCode)
        })
        
        self.shopRef.child(Share.shopID).child("product").observe(.value) { (snap) in
            guard let value = snap.value else {return}
            let object = JSON(value)
            
            var tempNames = [String]()
            var tempPrices = [String]()
            var tempImages = [String]()
            
            for (key,sub):(String, JSON) in object {
                if Share.filterOption == "" {
                    tempNames.append(sub["name"].stringValue)
                    tempPrices.append(sub["price"].stringValue)
                    tempImages.append(key)
                }else {
                    if sub["category"].stringValue == Share.filterOption {
                        tempNames.append(sub["name"].stringValue)
                        tempPrices.append(sub["price"].stringValue)
                        tempImages.append(key)
                    }
                }
            }
            
            if self.imageKeys.isEmpty == true {
                self.imageKeys = tempImages
                self.names = tempNames
                self.prices = tempPrices
                
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            }else {
                if self.imageKeys.count < tempImages.count {
                    let newKeys = tempImages.filter{ !self.imageKeys.contains($0) }
                    let newNames = tempNames.filter{ !self.names.contains($0) }
                    let newPrices = tempPrices.filter{ !self.prices.contains($0) }
                    
                    self.names.append(contentsOf: newNames)
                    self.imageKeys.append(contentsOf: newKeys)
                    self.prices.append(contentsOf: newPrices)
                    
                    self.collectionView.reloadData()
                }else if self.imageKeys.count > tempImages.count {
                    self.names = self.names.filter {tempNames.contains($0)}
                    self.prices = self.prices.filter {tempPrices.contains($0)}
                    self.imageKeys = self.imageKeys.filter {tempImages.contains($0)}
                    
                    self.collectionView.reloadData()
                }else {
                    print("Data is the same")
                }
            }
        }
        
        if ARSLineProgress.shown == true {
            ARSLineProgress.hide()
        }
    }
}

extension haveShopVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if self.names.isEmpty == false {
            numOfSections = 1
            collectionView.backgroundView = nil
        }else {
            collectionView.backgroundView  = self.noProductView
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        let width = collectionViewSize/2
        let height = width + 60
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.productCurrency.text = Share.currentCurrencyCode
        cell.productName.text = self.names[indexPath.row]
        cell.productPrice.text = self.prices[indexPath.row]
        
        self.imageRef.child(self.imageKeys[indexPath.row]).getData(maxSize: 1 * 1024 * 1024) { (data, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                let tempImage = UIImage(data: data!)
                cell.productImage.image = tempImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Share.chosenProduct = self.imageKeys[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "chosenProductVC") as! chosenProductVC
        self.present(viewController, animated: true, completion: nil)
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
        self.reloadData()
        self.refresher.endRefreshing()
    }
}
