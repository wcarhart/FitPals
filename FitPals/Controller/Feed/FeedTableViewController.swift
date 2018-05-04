//
//  FeedTableViewController.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var testUser = User(named: "Will Carhart")
    
    var testPosts: [Post]!

    override func viewDidLoad() {
        super.viewDidLoad()
        testPosts = [
            Post(owner: testUser, workout: nil, pictures: nil, dietPlan: nil, text: "test post 0")!,
            Post(owner: testUser, workout: nil, pictures: nil, dietPlan: nil, text: "test post 1")!,
            Post(owner: testUser, workout: nil, pictures: nil, dietPlan: nil, text: "test post 2")!
        ]
        testUser.addPosts(testPosts)
        testUser.picture = #imageLiteral(resourceName: "demo_image")
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        }
        
        let post = testPosts[indexPath.row]
        
        cell.profileNameLabel?.text = post.owner.name
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.postDateLabel?.text = dateFormatter.string(from: today)
        cell.postContentLabel?.text = post.text
        cell.postScoreLabel?.text = String(post.score)
        cell.profileIcon.image = #imageLiteral(resourceName: "demo_image") //post.owner.picture

        return cell
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
