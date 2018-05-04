//
//  PostTableViewCell.swift
//  FitPals
//
//  Created by Will Carhart on 5/4/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    // post info view (top)
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    // post content view (middle)
    @IBOutlet weak var postContentLabel: UILabel!
    
    // post details view (bottom)
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var postScoreLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func profileTapped(_ sender: UIButton) {
        print("Going to \(profileNameLabel.text ?? "nil")'s profile page")
    }
    
    @IBAction func upvoteButtonPressed(_ sender: UIButton) {
        print("Upvoted")
    }
    
    @IBAction func downvoteButtonPressed(_ sender: UIButton) {
        print("Downvoted")
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print("Commenting")
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        print("Sharing")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
