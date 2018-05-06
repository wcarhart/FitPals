//
//  FeedViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseAuth
import Firebase
import PKHUD

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    // for TableView and ScrollView delegates
    let maxHeaderHeight: CGFloat = 108
    let minHeaderHeight: CGFloat = 64
    var previousScrollOffset: CGFloat = 0
    
    // for TableView source
    var numberOfPosts: Int = 0
    
    override func viewDidLoad() {
        HUD.show(.progress)
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        headerView.backgroundColor = FlatWhite()
        self.view.backgroundColor = FlatWhiteDark()
        self.tableView.backgroundColor = FlatWhiteDark()
        
        getPosts()
    }
    
    func getPosts() {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
            db.collection("users").document("\(uid)").collection("posts").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("ERROR: Could not retrieve documents, \(error)")
                } else {
                    var count = 0
                    for document in querySnapshot!.documents {
                        count += 1
                        self.numberOfPosts += 1
                        print("\(document.documentID) => \(document.data())");
                    }
                    
                    print("Count = \(count)");
                }
                self.tableView.reloadData()
                HUD.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightConstraint.constant = maxHeaderHeight
    }

}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return TestUserSingleton.shared.user.posts.count
        return self.numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PostTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell
        }
        
        let post = TestUserSingleton.shared.user.posts[indexPath.row]
        cell.delegate = self
        cell.postId = post.id
        
        cell.profileNameLabel?.text = TestUserSingleton.shared.user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.postDateLabel?.text = dateFormatter.string(from: post.date)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        var newHeight = self.headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
        }
        
        if newHeight != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeight
            self.setScrollPosition(position: self.previousScrollOffset)
        }
        
        
        self.previousScrollOffset = scrollView.contentOffset.y
    }
    
    func setScrollPosition(position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            // Manipulate UI elements within the header here
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            // Manipulate UI elements within the header here
            self.view.layoutIfNeeded()
        })
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
    
}
