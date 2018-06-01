//
//  chosenProductVC.swift
//  BossUp
//
//  Created by Trong Triet Le on 22/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import ARSLineProgress

class chosenProductVC: UIViewController {
    
    fileprivate let userRef = BackendManager.shared.userReference
    fileprivate let shopRef = BackendManager.shared.shopReference
    fileprivate let imageRef = BackendManager.shared.imageReference
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var quantityList = [String]()
    fileprivate var sizeList = [String]()
    fileprivate var sizeQuantity = [String]()
    
    fileprivate var quantityDictionary = [String:String]()
    
    fileprivate var reducedQuantity = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressConfirmButton(_ sender: UIButton) {
        if self.quantityDictionary.isEmpty == false {
            self.updateBackend()
            self.dismiss(animated: true, completion: nil)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressDeleteButton(_ sender: UIButton) {
        shopRef.child(Share.shopID).child("product").child(Share.chosenProduct).removeValue()
        
        imageRef.child(Share.chosenProduct).delete { (err) in
            if let err = err {
                print(err)
                self.showAlert(title: "", message: err.localizedDescription)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("updateChosenProduct"), object: nil)
        
        Share.chosenProductEdit = Share.chosenProduct
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "addProductVC") as! addProductVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc fileprivate func updateUI() {
        if ARSLineProgress.shown == false {
            ARSLineProgress.showWithPresentCompetionBlock {
                self.getData()
                _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)
            }
        }else {
            self.getData()
        }
    }
    
    fileprivate func getData() {
        self.quantityList = []
        self.sizeList = []
        self.sizeQuantity = []
        shopRef.child(Share.shopID).child("product").child(Share.chosenProduct).observeSingleEvent(of: .value) { (snapShot) in
            
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            
            Share.chosenProductName = json["name"].stringValue
            Share.chosenProductPrice = json["price"].stringValue
            Share.choseProductCapital = json["capital"].stringValue
            
            let productName = json["name"].stringValue + "-" + json["price"].stringValue + " \(Share.currentCurrencyCode)"
            self.productLabel.text = productName
            
            for (key,subJSON):(String, JSON) in json["quantity"] {
                if subJSON["quantity"].stringValue != "0" {
                    self.quantityList.append(key)
                    self.sizeList.append(subJSON["size"].stringValue)
                    self.sizeQuantity.append(subJSON["quantity"].stringValue)
                }
            }
            
            for _ in self.quantityList {
                self.reducedQuantity.append(0)
            }
        }
        
        imageRef.child(Share.chosenProduct).getData(maxSize: 1 * 1024 * 1024) { (data, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                let image = UIImage(data: data!)
                self.productImage.image = image!
                Share.chosenProductImage = image!
            }
        }
        if ARSLineProgress.shown == true {
            ARSLineProgress.hideWithCompletionBlock {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }else {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func updateBackend() {
        for item in self.quantityDictionary {
            shopRef.child(Share.shopID).child("product").child(Share.chosenProduct).child("quantity").child(item.key).updateChildValues(["quantity":item.value])
            
            let i = self.quantityList.index(of: item.key)!
            
            var parameter = [String:String]()
            parameter["productId"] = Share.chosenProduct
            parameter["productName"] = Share.chosenProductName
            parameter["time"] = Helper.shared.getTodayString()
            parameter["sellerId"] = Auth.auth().currentUser!.uid
            parameter["sellerEmail"] = Auth.auth().currentUser!.email!
            parameter["quantity"] = String(describing: -self.reducedQuantity[i])
            
            let moneyGet = Int(Share.chosenProductPrice)! * -(self.reducedQuantity[i])
            parameter["moneyGet"] = String(describing: moneyGet)
            
            let capitalGet = Int(Share.choseProductCapital)! * -(self.reducedQuantity[i])
            parameter["capital"] = String(describing: capitalGet)
            
            shopRef.child(Share.shopID).child("transaction").childByAutoId().updateChildValues(parameter)
        }
    }
    
    @objc fileprivate func timerAction() {
        if ARSLineProgress.shown == true {
            ARSLineProgress.hide()
        }
    }
}

extension chosenProductVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0
        if self.quantityList.count > 0 {
            numOfSections            = 1
            tableView.backgroundView = nil
        }else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Out of stock"
            noDataLabel.textColor     = UIColor.gray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quantityList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        cell.sizeLabel.text = self.sizeList[indexPath.row]
        
        cell.sellButton.addTarget(self, action:#selector(sellProductButton(sender:)), for: .touchUpInside)
        cell.sellButton.tag = indexPath.row
        
        if self.reducedQuantity[indexPath.row] != 0 {
            cell.reducedQuantityLabel.isHidden = false
            cell.reducedQuantityLabel.text = String(describing: self.reducedQuantity[indexPath.row])
            let tempQuality = Int(self.sizeQuantity[indexPath.row])! + self.reducedQuantity[indexPath.row]
            cell.quantityLabel.text = String(describing: tempQuality)
        }else {
            cell.reducedQuantityLabel.isHidden = true
            cell.quantityLabel.text = self.sizeQuantity[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc fileprivate func sellProductButton(sender: UIButton) {
        print("Button index \(sender.tag)")
        
        let index = sender.tag
        let tempQuantity = Int(self.sizeQuantity[index])!
        let tempReducedQuantity = self.reducedQuantity[index] * -1
        print(tempQuantity)
        print(tempReducedQuantity)
        if tempQuantity > 0 && tempReducedQuantity < tempQuantity {
            self.reducedQuantity[index] = self.reducedQuantity[index] - 1
            
            self.quantityDictionary.updateValue(String(describing: self.reducedQuantity[index] + tempQuantity), forKey: self.quantityList[index])
        }
        print(self.quantityDictionary)
        self.tableView.reloadData()
    }
}
