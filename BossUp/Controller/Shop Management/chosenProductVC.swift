//
//  chosenProductVC.swift
//  BossUp
//
//  Created by Trong Triet Le on 22/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON
import ARSLineProgress

class chosenProductVC: UIViewController {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var quantityList = [String]()
    fileprivate var sizeList = [String]()
    fileprivate var sizeQuantity = [String]()
    
    fileprivate var editedQuantityID = [String]()
    fileprivate var editedQuantity = [String]()
    
    fileprivate var reducedQuantity = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARSLineProgress.showWithPresentCompetionBlock {
            self.getData()
        }
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("dismissChosenProduct"), object: nil)
        }
    }
    
    
    fileprivate func getData() {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("product").child(SharedInstance.chosenProduct).observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {return}
            let json = JSON(value)
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
            }
        }
        ARSLineProgress.hideWithCompletionBlock {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
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
            noDataLabel.textColor     = UIColor.lightGray
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
            
            if self.editedQuantityID.contains(self.quantityList[index]) == false {
                self.editedQuantityID.append(self.quantityList[index])
            }
            
            if self.editedQuantity.count < index+1{
                self.editedQuantity.append(String(describing: self.reducedQuantity[index] + tempQuantity))
            }else {
                if self.editedQuantity[index] != String(describing: self.reducedQuantity[index] + tempQuantity) {
                    self.editedQuantity[index] = String(describing: self.reducedQuantity[index] + tempQuantity)
                }
            }
        }
        print(editedQuantityID)
        print(editedQuantity)
        self.tableView.reloadData()
    }
}
