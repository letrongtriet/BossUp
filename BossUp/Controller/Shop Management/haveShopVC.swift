//
//  haveShopVC.swift
//  BossUp
//
//  Created by Triet Le on 28/03/2018.
//  Copyright © 2018 Trong Triet Le. All rights reserved.
//

import UIKit

class haveShopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("haveShopVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("haveShopVC Will Appear")
    }

}

extension haveShopVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        return cell
    }
    
    
}
