//
//  chartsVC.swift
//  BossUp
//
//  Created by Triet Le on 05/04/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class chartsVC: UIViewController {
    fileprivate let userRef = BackendManager.shared.userReference
    fileprivate let shopRef = BackendManager.shared.shopReference
    
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    fileprivate var transactionList = [String]()
    fileprivate var entries = [PieChartDataEntry]()
    fileprivate var chartColors = [UIColor]()
    
    fileprivate var revenue:Int = 0
    fileprivate var proift:Int = 0
    
    fileprivate var products: [String: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        if Share.shopID == "" {
            print("Chart VC cannot be loaded")
        }else {
            self.getReportData()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reload), name: Notification.Name("reloadChart"), object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func reload() {
        self.transactionList = []
        self.entries = []
        self.chartColors = []
        self.revenue = 0
        self.proift = 0
        self.pieChartView.data = nil
        self.products = [:]
        self.getReportData()
    }
    
    @objc fileprivate func getReportData() {
        shopRef.child(Share.shopID).child("transaction").observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            
            for (_,transaction):(String,JSON) in json {
                
                if Helper.shared.compareDate(transactionDate: transaction["time"].stringValue) <= Share.transactionFilter {
                    self.transactionList.append(transaction["productName"].stringValue)
                    let money = transaction["moneyGet"].intValue
                    let capital = transaction["capital"].intValue
                    
                    self.revenue += money
                    self.proift += (money-capital)
                }
                
            }
            
            self.updateChartData()
            self.updateLabel()
        }
    }
    
    fileprivate func updateChartData() {
        
        self.pieChartView.chartDescription?.text = nil
        
        for item in self.transactionList {
            self.products[item] = (self.products[item] ?? 0) + 1
        }
        print(self.products)
        for (key, value) in self.products {
            let entry = PieChartDataEntry(value: 0)
            entry.value = Double(value)
            entry.label = key
            
            self.entries.append(entry)
            
            self.chartColors.append(UIColor.random())
        }
        
        let chartDataSet = PieChartDataSet(values: self.entries, label: nil)
        chartDataSet.colors = self.chartColors
        let chartData = PieChartData(dataSet: chartDataSet)
        
        self.pieChartView.data = chartData
    }
    
    fileprivate func updateLabel() {
        if Share.isOwner == false {
            self.revenueLabel.isHidden = true
            self.profitLabel.isHidden = true
        }else {
            self.revenueLabel.text = String(describing: self.revenue)
            self.profitLabel.text = String(describing: self.proift)
        }
    }
}
