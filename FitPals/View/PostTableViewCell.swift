//
//  PostTableViewCell.swift
//  FitPals
//
//  Created by Will Carhart on 5/4/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol PostTableViewCellDelegate {
    func upvote(postId: Int32)
    func downvote(postId: Int32)
}

class PostTableViewCell: UITableViewCell {
    
    var delegate: PostTableViewCellDelegate?
    var postId: Int32!
    
    // post info view (top)
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    // post content view (middle)
    @IBOutlet weak var postContentView: UIView!
    
    // post details view (bottom)
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var postScoreLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // views (for coloring)
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var contentContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.backgroundColor = FlatWhiteDark()
        paddingView.backgroundColor = FlatWhite()
        contentContainer.backgroundColor = FlatWhite()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }

    @IBAction func profileTapped(_ sender: UIButton) {
        print("LOG: profile")
    }
    
    @IBAction func upvoteButtonPressed(_ sender: UIButton) {
        delegate?.upvote(postId: postId)
        
        if let result = TestUserSingleton.shared.user.votes[postId] {
            if result {
                DispatchQueue.main.async {
                    self.upvoteButton.imageView?.image = #imageLiteral(resourceName: "upvote_selected")
                    self.downvoteButton.imageView?.image = #imageLiteral(resourceName: "downvote")
                }
            } else {
                DispatchQueue.main.async {
                    self.upvoteButton.imageView?.image = #imageLiteral(resourceName: "upvote")
                    self.downvoteButton.imageView?.image = #imageLiteral(resourceName: "downvote")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.upvoteButton.imageView?.image = #imageLiteral(resourceName: "upvote")
            }
        }
        
        var index = 0
        for post in TestUserSingleton.shared.user.posts {
            if post.id == postId {
                break
            } else {
                index += 1
            }
        }
        self.postScoreLabel.text = String(TestUserSingleton.shared.user.posts[index].score)
        
        print("LOG: updoot")
    }
    
    @IBAction func downvoteButtonPressed(_ sender: UIButton) {
        delegate?.downvote(postId: postId)
        
        if let result = TestUserSingleton.shared.user.votes[postId] {
            if !result {
                DispatchQueue.main.async {
                    self.downvoteButton.imageView?.image = #imageLiteral(resourceName: "downvote_selected")
                    self.upvoteButton.imageView?.image = #imageLiteral(resourceName: "upvote")
                }
            } else {
                DispatchQueue.main.async {
                    self.downvoteButton.imageView?.image = #imageLiteral(resourceName: "downvote")
                    self.upvoteButton.imageView?.image = #imageLiteral(resourceName: "upvote")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.downvoteButton.imageView?.image = #imageLiteral(resourceName: "downvote")
            }
        }
        
        var index = 0
        for post in TestUserSingleton.shared.user.posts {
            if post.id == postId {
                break
            } else {
                index += 1
            }
        }
        self.postScoreLabel.text = String(TestUserSingleton.shared.user.posts[index].score)
        
        print("LOG: downvote")
    }
    
    @IBAction func commentButtonDown(_ sender: UIButton) {
        commentButton.imageView?.image = #imageLiteral(resourceName: "comment_full")
    }
    
    @IBAction func commentButtonUp(_ sender: UIButton) {
        commentButton.imageView?.image = #imageLiteral(resourceName: "comment_hollow")
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print("LOG: comment")
    }
    
    @IBAction func shareButtonDown(_ sender: UIButton) {
        shareButton.imageView?.image = #imageLiteral(resourceName: "share_full")
    }
    
    @IBAction func shareButtonUp(_ sender: UIButton) {
        shareButton.imageView?.image = #imageLiteral(resourceName: "share_hollow")
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print("LOG: share")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
