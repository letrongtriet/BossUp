//
//  settingsController.swift
//  BossUp
//
//  Created by Trong Triet Le on 16/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown

class settingsController: UIViewController {
    
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var currencyButton: UIButton!
    
    @IBOutlet weak var menuButton: MyButton!
    let dropDown = DropDown()
    
    fileprivate var currencyList = ["Current currency: \(SharedInstance.currentCurrencyCode)"]
    fileprivate var currencyCodeList = [String]()
    
    let currencyData = NSData(contentsOfFile: Bundle.main.path(forResource: "Common-Currency", ofType: "json")!)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPicker()
        self.menuButton.addedTouchArea = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setShadow()
    }
    
    @IBAction func didPressCurrencyButton(_ sender: UIButton) {
        self.dropDown.show()
    }
    
    fileprivate func setShadow() {
        menuBar.layer.shadowColor = UIColor.lightGray.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuBar.layer.shadowRadius = 2
    }
    
    fileprivate func currencyPicker() {
        do {
            let json = try JSON(data: currencyData! as Data)
            for (key,subJSON):(String,JSON) in json {
                let temp = key + " - " + subJSON["name"].stringValue
                self.currencyList.append(temp)
                self.currencyCodeList.append(key)
            }
            
            let temp = currencyCodeList.sorted()
            self.currencyCodeList = temp
            print(self.currencyCodeList)
            
            dropDown.anchorView = self.currencyButton
            dropDown.bottomOffset = CGPoint(x: 0, y: currencyButton.bounds.height)
            DropDown.appearance().backgroundColor = .white
            DropDown.appearance().cornerRadius = 10
            DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
            self.dropDown.dataSource = self.currencyList.sorted()
            self.currencyButton.setTitle(currencyList.first!, for: .normal)
            
            // Action triggered on selection
            dropDown.selectionAction = { [weak self] (index, item) in
                print(item)
                self?.currencyButton.setTitle(item, for: .normal)
                SharedInstance.currentCurrencyCode = (self?.currencyCodeList[index-1])!
                BackendManager.shared.shopReference.child(SharedInstance.shopID).child("currentCurrencyCode").setValue(self?.currencyCodeList[index-1])
            }
        } catch {
            self.showAlert(title: "Error", message: "Cannot find currency.")
        }
    }

}
