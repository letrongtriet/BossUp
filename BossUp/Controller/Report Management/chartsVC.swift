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
        if SharedInstance.shopID == "" {
            print("Chart VC cannot be loaded")
        }else {
            self.getReportData()
        }
    }
    
    fileprivate func getReportData() {
        BackendManager.shared.shopReference.child(SharedInstance.shopID).child("transaction").observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {return}
            let json = JSON(value)
            
            for (_,transaction):(String,JSON) in json {
                self.transactionList.append(transaction["productName"].stringValue)
                let money = transaction["moneyGet"].intValue
                let capital = transaction["capital"].intValue

                self.revenue += money
                self.proift += (money-capital)
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
        if SharedInstance.isOwner == false {
            self.revenueLabel.isHidden = true
            self.profitLabel.isHidden = true
        }else {
            self.revenueLabel.text = String(describing: self.revenue)
            self.profitLabel.text = String(describing: self.proift)
        }
    }
}
