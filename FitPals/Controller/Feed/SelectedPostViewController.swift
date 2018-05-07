//
//  SelectedPostViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class SelectedPostViewController: UIViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        print("LOG: returning from SelectedPostViewController")
        performSegue(withIdentifier: "unwindToFeed", sender: nil)
    }

}
