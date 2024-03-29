//
//  ProfileTableViewController.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    let defaultRowHeight : CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0,0]:
            var cell: ProfileTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as? ProfileTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell") as? ProfileTableViewCell
            }
            return cell
        case [0,1]:
            var cell: AboutTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AboutTableCell") as? AboutTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "AboutTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutTableCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "AboutTableCell") as? AboutTableViewCell
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostCell", for: indexPath)
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case [0,0], [0,1]:
            return(176) //height of first and second cell (Profile picture and info Sections)
        default:
            return(defaultRowHeight)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
