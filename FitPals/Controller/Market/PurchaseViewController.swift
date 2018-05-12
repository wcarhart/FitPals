//
//  PurchaseViewController.swift
//  FitPals
//
//  Created by Gautam Daryanani on 5/2/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cart : [Product] = [Product(temp: "test")]
    
    @IBOutlet weak var cartTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.rowHeight = 200
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count+3 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath as IndexPath
            switch index {
                default:
                    var cell: CartTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as? CartTableViewCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableCell")
                        cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as? CartTableViewCell
                    }
                return cell
                }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // cell selected code here
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
