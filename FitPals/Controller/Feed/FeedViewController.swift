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

class FeedViewController: UIViewController, ComposeMenuDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    // for TableView and ScrollView delegates
    let maxHeaderHeight: CGFloat = 108
    let minHeaderHeight: CGFloat = 64
    var previousScrollOffset: CGFloat = 0
    
    // for TableView source
    var numberOfPosts: Int = 0
    
    var newPostType: PostType!
    
    var transitionStyle: UIModalTransitionStyle?
    
    var selectedPost: Post?
    
    override func viewDidLoad() {
        
        // TODO: get this flip segue actually working, will need a custom animation controller (see SO)
        if self.transitionStyle != nil {
            modalTransitionStyle = .flipHorizontal
        }
        
        HUD.show(.progress)
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // TODO: optimize this for foldable header in scroll view (messes up colors)
        headerView.backgroundColor = FlatWhiteDark()
        self.tableView.backgroundColor = GradientColor(.topToBottom, frame: self.view.frame, colors: [RandomFlatColor(), RandomFlatColor()])
        
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
                self.animateCells()
                HUD.hide()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightConstraint.constant = maxHeaderHeight
    }

    var composeMenuController = ComposeMenuController()
    @IBAction func composeButtonPressed(_ sender: UIButton) {
        composeMenuController.delegate = self
        composeMenuController.showComposeMenu()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        print("LOG: settings button pressed")
        let alertController = UIAlertController(title: "Would you like to log out?", message: "More settings comming soon...", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: handleLogOut)
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: handleCancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleCancel(_ alert: UIAlertAction) {
        print("LOG: settings cancelled")
    }
    
    func handleLogOut(_ alert: UIAlertAction) {
        print("LOG: logging out user \(Auth.auth().currentUser?.displayName ?? "<NO NAME>")")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "unwindToLoginScreen", sender: nil)
    }
    
    func updateParent(with postType: PostType) {
        self.newPostType = postType
        performSegue(withIdentifier: "createNewPost", sender: nil)
    }
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateNewPostViewController {
            destination.postType = self.newPostType
        } else if let destination = segue.destination as? SelectedPostViewController {
            destination.post = self.selectedPost
        }
    }
    
}

extension FeedViewController: UITableViewDataSource {
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
        let contentHeight = configureContent(for: post, onCell: cell)
        cell.contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        
        cell.postScoreLabel?.text = String(post.score)
        if let picture = TestUserSingleton.shared.user.picture {
            cell.profileIcon.image = UIImage(named: picture)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func configureContent(for post: Post, onCell cell: PostTableViewCell) -> CGFloat {
        /*
         * post content is configured into the PostContent.xib format:
         *  - text
         *  - workout
         *  - diet
         *  - image
         *  -- 4 image display (large thumbnails
         *  -- 8 image display (small thumbnails)
         *
         *  YOU MUST CALL THE setPostType(to:) METHOD WHEN CONFIGURING THE CELL
         *  YOU MUST ALSO CALL THE setNumberOfImages(to:) METHOD IF IMAGE POST
         *
         */
        
        // here is are a few simple example of how to use this implementation:
        
        // four images model
        cell.postContentCustomizableView.setPostType(to: .image)
        cell.postContentCustomizableView.setNumberOfImages(to: 4)
        cell.postContentCustomizableView.fourImagesTopLeftImage.image = #imageLiteral(resourceName: "workout_demo_1")
        cell.postContentCustomizableView.fourImagesTopRightImage.image = #imageLiteral(resourceName: "workout_demo_2")
        cell.postContentCustomizableView.fourImagesBottomLeftImage.image = #imageLiteral(resourceName: "workout_demo_3")
        cell.postContentCustomizableView.fourImagesBottomRightImage.image = #imageLiteral(resourceName: "workout_demo_4")
        cell.postContentCustomizableView.fourImagesLabel.text = "Check out these cool pictures from my workout!"
        
        // eight images model
//        cell.postContentCustomizableView.setPostType(to: .image)
//        cell.postContentCustomizableView.setNumberOfImages(to: 8)
//        cell.postContentCustomizableView.setImages(with: [#imageLiteral(resourceName: "workout_demo_1"), #imageLiteral(resourceName: "workout_demo_2"), #imageLiteral(resourceName: "workout_demo_3"), #imageLiteral(resourceName: "workout_demo_4")])
        
        
        // text model
//        cell.postContentCustomizableView.setPostType(to: .text)
//        cell.postContentCustomizableView.textPostLabel.text = "I can't believe the gym is closed today!"
        
        // TODO: will need to be implemented for non-static content
        // i.e. text only, pictures only, pictures + text, workouts only, etc.
        //cell.postScoreLabel.text = post.score
        
        // this will be used to draw the cell height
        print("LOG: returned cell height of \(cell.postContentCustomizableView.calculateHeight())")
        //return cell.postContentCustomizableView.calculateHeight()
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
        
        print("LOG: Post #\(postId) now has a score of \(TestUserSingleton.shared.user.posts[index].score)")
        print("LOG: User #\(TestUserSingleton.shared.user.id) has now voted for:")
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
        
        print("LOG: Post #\(postId) now has a score of \(TestUserSingleton.shared.user.posts[index].score)")
        print("LOG: User #\(TestUserSingleton.shared.user.id) has now voted for:")
        for post in TestUserSingleton.shared.user.votes {
            print("  Post #\(post.key): \(post.value ? "upvote" : "downvote")")
        }
    }
}

extension FeedViewController: UITableViewDelegate, PostTableViewCellDelegate {
    
    func animateCells() {
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableHeight: CGFloat = self.tableView.bounds.size.height
        
        for cellAtIndex in cells {
            let cell: UITableViewCell = cellAtIndex as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        for cellAtIndex in cells {
            let cell: UITableViewCell = cellAtIndex as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print("LOG: user selected post at row \(indexPath.row)")
        
        // TODO: pull this from Firestore, currently incomplete
        self.selectedPost = nil
        
        performSegue(withIdentifier: "showSelectedPost", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        // TODO: finalize top bar, then uncomment this for animations
        //self.titleTopConstraint.constant = -openAmount + 10
        //self.logoImageView.alpha = percentage
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // make sure that when header is collapsed, there is still room to scroll
        //return scrollView.contentSize.height > scrollViewMaxHeight
        
        // TODO: defaults true to show functionality, need to update when non-static content is implemented
        return true
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
}
