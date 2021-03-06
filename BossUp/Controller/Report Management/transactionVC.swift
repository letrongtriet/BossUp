//
//  transactionVC.swift
//  BossUp
//
//  Created by Trong Triet Le on 27/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON

class transactionVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var transactionList = [String]()
    fileprivate var nameList = [String]()
    fileprivate var timeList = [String]()
    fileprivate var sellerList = [String]()
    fileprivate var quantityList = [String]()
    fileprivate var priceList = [String]()
    fileprivate var totalList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 200
        self.tableView.tableFooterView = UIView()
        self.getData()
    }
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func getData() {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("transaction").observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            
            for (key,transaction):(String,JSON) in json {
                if self.transactionList.contains(key) == false {
                    self.transactionList.append(key)
                    self.nameList.append(transaction["productName"].stringValue)
                    self.timeList.append(transaction["time"].stringValue)
                    self.sellerList.append(transaction["sellerEmail"].stringValue)
                    self.quantityList.append(transaction["quantity"].stringValue)
                    self.totalList.append(transaction["moneyGet"].stringValue)
                    
                    let quantity = Int(transaction["quantity"].stringValue)!
                    let money = Int(transaction["moneyGet"].stringValue)!
                    self.priceList.append(String(describing: money/quantity))
                }
            }
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}

extension transactionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0
        
        if self.transactionList.isEmpty == false {
            numOfSections            = 1
            tableView.backgroundView = nil
        }else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No transaction was found"
            noDataLabel.textColor     = UIColor.gray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! transactionCell
        
        cell.name.text = self.nameList[indexPath.row]
        cell.time.text = "Time: \(self.timeList[indexPath.row])"
        cell.seller.text = "Seller: \(self.sellerList[indexPath.row])"
        cell.quantity.text = "Quantity: \(self.quantityList[indexPath.row]) x \(self.priceList[indexPath.row]) \(SharedInstance.currentCurrencyCode)"
        cell.price.text = "\(self.totalList[indexPath.row]) \(SharedInstance.currentCurrencyCode)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
