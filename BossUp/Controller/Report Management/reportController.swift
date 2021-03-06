//
//  reportController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Charts
import ARSLineProgress
import Firebase
import SwiftyJSON

class reportController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var index:Int = -1
    fileprivate var currentStaffName = ""
    fileprivate var currentStaffKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 50
        print("report")
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        NavigationManager.shared.masterMenu()
    }
    
    @IBAction func didPressOpenTransaction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "transactionVC") as! transactionVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.lightGray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func getData() {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("member").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value else {return}
            let json = JSON(value)
            
            for (key,sub):(String,JSON) in json {
                if sub["member"].null == nil {
                    SharedInstance.currentShopStaffs.updateValue(sub["member"].stringValue, forKey: key)
                }
            }
            print(SharedInstance.currentShopStaffs)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}

extension reportController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0
        
        if SharedInstance.isOwner == true {
            numOfSections            = 1
            tableView.backgroundView = nil
        }else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No staff was added"
            noDataLabel.textColor     = UIColor.gray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedInstance.currentShopStaffs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! TableViewCellReport
        
        cell.staffName.text = Array(SharedInstance.currentShopStaffs)[indexPath.row].value
        cell.removeButton.addTarget(self, action:#selector(removeMember(sender:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc fileprivate func removeMember(sender:UIButton) {
        self.index = sender.tag
        self.currentStaffName = Array(SharedInstance.currentShopStaffs)[self.index].value
        self.currentStaffKey = Array(SharedInstance.currentShopStaffs)[self.index].key
        self.alertView()
    }
    
    fileprivate func alertView() {
        let alert = UIAlertController(title: nil, message: "Do you want to remove \n \(self.currentStaffName)", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            BackendManager.shared.shopReference.child(SharedInstance.shopID).child("member").child(self.currentStaffKey).removeValue()
            BackendManager.shared.userReference.child(self.currentStaffKey).child("shop").child(SharedInstance.shopID).removeValue()
            SharedInstance.currentShopStaffs.removeValue(forKey: self.currentStaffKey)
            self.getData()
        })
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
