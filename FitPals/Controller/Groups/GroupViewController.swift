//
//  GroupViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/18/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework

class GroupViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dummyData: [String] = [
        "YMCA", "Mission Fitness Center", "Crunch Fitness"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension GroupViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCollectionViewCell", for: indexPath) as! GroupCollectionViewCell
        
        cell.groupTitle.text = dummyData[indexPath.row]
        cell.backgroundColor = FlatGray()
        
        return cell
    }
}
