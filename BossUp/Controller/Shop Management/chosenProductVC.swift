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
        ARSLineProgress.showWithPresentCompetionBlock {
            self.getData()
        }
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("dismissChosenProduct"), object: nil)
        }
    }
    
    @IBAction func didPressConfirmButton(_ sender: UIButton) {
        if self.quantityDictionary.isEmpty == false {
            self.updateBackend()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("dismissChosenProduct"), object: nil)
            }
        }else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("dismissChosenProduct"), object: nil)
            }
        }
    }
    
    @IBAction func didPressDeleteButton(_ sender: UIButton) {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(SharedInstance.chosenProduct).removeValue()
        
        BackendManager.shared.imageReference.child(SharedInstance.chosenProduct).delete { (err) in
            if let err = err {
                print(err)
                self.showAlert(title: "", message: err.localizedDescription)
            }else {
                let newList = SharedInstance.productList.filter { $0 != SharedInstance.chosenProduct }
                SharedInstance.productList = newList
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("dismissChosenProduct"), object: nil)
                }
            }
        }
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissAddProduct), name: Notification.Name("dismissAddProductFromChosen"), object: nil)
        
        SharedInstance.chosenProductEdit = SharedInstance.chosenProduct
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "addProductVC") as! addProductVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func getData() {
        self.quantityList = []
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(SharedInstance.chosenProduct).observeSingleEvent(of: .value) { (snapShot) in
            
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            
            SharedInstance.chosenProductName = json["name"].stringValue
            SharedInstance.chosenProductPrice = json["price"].stringValue
            SharedInstance.choseProductCapital = json["capital"].stringValue
            
            let productName = json["name"].stringValue + "-" + json["price"].stringValue + " \(SharedInstance.currentCurrencyCode)"
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
        
        BackendManager.shared.imageReference.child(SharedInstance.chosenProduct).getData(maxSize: 1 * 1024 * 1024) { (data, err) in
            if let err = err {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                let image = UIImage(data: data!)
                self.productImage.image = image!
                SharedInstance.chosenProductImage = image!
            }
        }
        ARSLineProgress.hideWithCompletionBlock {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func dismissAddProduct() {
        ARSLineProgress.showWithPresentCompetionBlock {
            self.getData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func updateBackend() {
        for item in self.quantityDictionary {
            BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(SharedInstance.chosenProduct).child("quantity").child(item.key).updateChildValues(["quantity":item.value])
            
            let i = self.quantityList.index(of: item.key)!
            
            var parameter = [String:String]()
            parameter["productId"] = SharedInstance.chosenProduct
            parameter["productName"] = SharedInstance.chosenProductName
            parameter["time"] = Helper.shared.getTodayString()
            parameter["sellerId"] = Auth.auth().currentUser!.uid
            parameter["sellerEmail"] = Auth.auth().currentUser!.email!
            parameter["quantity"] = String(describing: -self.reducedQuantity[i])
            
            let moneyGet = Int(SharedInstance.chosenProductPrice)! * -(self.reducedQuantity[i])
            parameter["moneyGet"] = String(describing: moneyGet)
            
            let capitalGet = Int(SharedInstance.choseProductCapital)! * -(self.reducedQuantity[i])
            parameter["capital"] = String(describing: capitalGet)
            
            BackendManager.shared.shopReference.child(SharedInstance.shopID).child("transaction").childByAutoId().updateChildValues(parameter)
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
        cell.quantityLabel.text = self.sizeQuantity[indexPath.row]
        cell.sellButton.addTarget(self, action:#selector(sellProductButton(sender:)), for: .touchUpInside)
        cell.sellButton.tag = indexPath.row
        
        if self.reducedQuantity[indexPath.row] != 0 {
            cell.reducedQuantityLabel.isHidden = false
            cell.reducedQuantityLabel.text = String(describing: self.reducedQuantity[indexPath.row])
        }else {
            cell.reducedQuantityLabel.isHidden = true
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
