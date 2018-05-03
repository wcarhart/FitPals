//
//  PurchaseViewController.swift
//  FitPals
//
//  Created by Gautam Daryanani on 5/2/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    var cart : [Product] = [Product(temp: "test")]
    @IBOutlet weak var cartTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count // your number of cell here
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CartTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
