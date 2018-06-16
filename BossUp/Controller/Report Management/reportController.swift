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
import DropDown

class reportController: UIViewController {
    
    fileprivate let userRef = BackendManager.shared.userReference
    fileprivate let shopRef = BackendManager.shared.shopReference
    
    weak var delegate: FilterChangedDelegate?
    
    @IBOutlet weak var menuButton: MyButton!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterLabel: UILabel!
    
    fileprivate var index:Int = -1
    fileprivate var currentStaffName = ""
    fileprivate var currentStaffKey = ""
    
    fileprivate let filterDropDown = DropDown()
    fileprivate let filterList = ["Today","Yesterday","7 days","30 days","1 year","All"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 50
        
        self.menuButton.addedTouchArea = 60
        
        self.updateLabel()
        
        if Share.shopID == "" {
            print("Report VC cannot be loaded")
        }else {
            self.getData()
        }
        
        self.setUpFilterDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? chartsVC,
            segue.identifier == "toChartVC" {
            vc.shopManagement = self
        }
    }
    
    @IBAction func didPressOpenTransaction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "transactionVC") as! transactionVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didPressFilterButton(_ sender: UIButton) {
        self.filterDropDown.show()
    }
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.lightGray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func getData() {
        shopRef.child(Share.shopID).child("member").observeSingleEvent(of: .value) { (snap) in
            guard let value = snap.value else {return}
            let json = JSON(value)
            
            for (key,sub):(String,JSON) in json {
                if sub["member"].null == nil {
                    Share.currentShopStaffs.updateValue(sub["member"].stringValue, forKey: key)
                }
            }
            print(Share.currentShopStaffs)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setUpFilterDropDown() {
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        
        filterDropDown.anchorView = self.filterButton
        filterDropDown.bottomOffset = CGPoint(x: 0, y: filterButton.bounds.height)
        
        filterDropDown.dataSource = self.filterList
        
        // Action triggered on selection
        filterDropDown.selectionAction = { [weak self] (index, item) in
            self?.filterLabel.text = item
            
            switch item {
            case "Today":
                Share.transactionFilter = 0
            case "Yesterday":
                Share.transactionFilter = 1
            case "7 days":
                Share.transactionFilter = 7
            case "30 days":
                Share.transactionFilter = 30
            case "1 year":
                Share.transactionFilter = 365
            case "All":
                Share.transactionFilter = Int.max
            default:
                Share.transactionFilter = 30
            }
            
            self?.getData()
            self?.delegate?.updateData()
        }
    }
    
    fileprivate func updateLabel() {
        switch Share.transactionFilter {
        case 0:
            self.filterLabel.text = "Today"
        case 1:
            self.filterLabel.text = "Yesterday"
        case 7:
            self.filterLabel.text = "7 days"
        case 30:
            self.filterLabel.text = "30 days"
        case 365:
            self.filterLabel.text = "1 year"
        case Int.max:
            self.filterLabel.text = "All"
        default:
            self.filterLabel.text = "30 days"
        }
    }
}

extension reportController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0
        
        if Share.isOwner == true {
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
        return Share.currentShopStaffs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! TableViewCellReport
        
        cell.staffName.text = Array(Share.currentShopStaffs)[indexPath.row].value
        cell.removeButton.addTarget(self, action:#selector(removeMember(sender:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc fileprivate func removeMember(sender:UIButton) {
        self.index = sender.tag
        self.currentStaffName = Array(Share.currentShopStaffs)[self.index].value
        self.currentStaffKey = Array(Share.currentShopStaffs)[self.index].key
        self.alertView()
    }
    
    fileprivate func alertView() {
        let alert = UIAlertController(title: nil, message: "Do you want to remove \n \(self.currentStaffName)", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.shopRef.child(Share.shopID).child("member").child(self.currentStaffKey).removeValue()
            self.userRef.child(self.currentStaffKey).child("shop").child(Share.shopID).removeValue()
            Share.currentShopStaffs.removeValue(forKey: self.currentStaffKey)
            self.getData()
        })
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
