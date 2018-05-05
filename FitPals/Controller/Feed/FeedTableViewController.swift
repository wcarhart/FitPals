//
//  FeedTableViewController.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, PostTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestUserSingleton.shared.user.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        }
        
        let post = TestUserSingleton.shared.user.posts[indexPath.row]
        cell.delegate = self
        cell.postId = post.id
        
        cell.profileNameLabel?.text = TestUserSingleton.shared.user.name
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.postDateLabel?.text = dateFormatter.string(from: today)
        
        // set content for post...
        let contentHeight = configureContent(for: post)
        cell.contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        
        cell.postScoreLabel?.text = String(post.score)
        if let picture = TestUserSingleton.shared.user.picture {
            cell.profileIcon.image = UIImage(named: picture)
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    func configureContent(for post: Post) -> CGFloat {
        
        // need to return the height of the content
        // this will be used to draw the cell height
        return 600.0
    }
    
    func upvote(postId: Int32) {
        
        var index = 0
        for post in TestUserSingleton.shared.user.posts {
            if post.id == postId {
                break
            } else {
                index += 1
            }
        }
        
        // update user's votes
        if TestUserSingleton.shared.user.votes[postId] == nil || TestUserSingleton.shared.user.votes[postId] == false {
            TestUserSingleton.shared.user.votes[postId] = true
        } else {
            TestUserSingleton.shared.user.votes[postId] = nil
        }
        
        // update post's votes
        if TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] == nil || TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] == false {
            TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] = true
        } else {
            TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] = nil
        }
        
        print("Post #\(postId) now has a score of \(TestUserSingleton.shared.user.posts[index].score)")
        print("User #\(TestUserSingleton.shared.user.id) has now voted for:")
        for post in TestUserSingleton.shared.user.votes {
            print("  Post #\(post.key): \(post.value ? "upvote": "downvote")")
        }
        
    }
    
    func downvote(postId: Int32) {
        
        var index = 0
        for post in TestUserSingleton.shared.user.posts {
            if post.id == postId {
                break
            } else {
                index += 1
            }
        }
        
        // update user's votes
        if TestUserSingleton.shared.user.votes[postId] == nil || TestUserSingleton.shared.user.votes[postId] == true {
            TestUserSingleton.shared.user.votes[postId] = false
        } else {
            TestUserSingleton.shared.user.votes[postId] = nil
        }
        
        // update post's votes
        if TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] == nil || TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] == true {
            TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] = false
        } else {
            TestUserSingleton.shared.user.posts[index].votes[TestUserSingleton.shared.user.id] = nil
        }
        
        print("Post #\(postId) now has a score of \(TestUserSingleton.shared.user.posts[index].score)")
        print("User #\(TestUserSingleton.shared.user.id) has now voted for:")
        for post in TestUserSingleton.shared.user.votes {
            print("  Post #\(post.key): \(post.value ? "upvote" : "downvote")")
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
