//
//  PostContent.swift
//  FitPals
//
//  Created by Will Carhart on 5/6/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class PostContent: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    
    // post type views - will be toggled based on post type
    @IBOutlet weak var textPostView: UIView!
    @IBOutlet weak var workoutPostView: UIView!
    @IBOutlet weak var dietPostView: UIView!
    @IBOutlet weak var imagePostView: UIView!
    
    // text
    @IBOutlet weak var textPostLabel: UILabel!
    
    // workout
    
    // diet
    
    // image
    
    private var postType: PostType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PostContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setPostType(to postType: PostType) {
        self.postType = postType
        updatePostType()
    }
    
    func updatePostType() {
        guard let postType = self.postType else {
            fatalError("ERROR: did not set postType for PostContent view. You must call the 'setPostType(to:)' before using this class")
        }
        
        self.textPostView.isHidden = true
        self.workoutPostView.isHidden = true
        self.dietPostView.isHidden = true
        self.imagePostView.isHidden = true
        
        switch postType {
        case .text:
            print("LOG: text post detected in PostContent")
            self.textPostView.isHidden = false
            self.textPostLabel.sizeToFit()
            self.textPostLabel.textAlignment = .left
        case .workout:
            print("LOG: workout post detected in PostContent")
            self.workoutPostView.isHidden = false
        case .diet:
            print("LOG: diet post detected in PostContent")
            self.dietPostView.isHidden = false
        case .image:
            print("LOG: image post detected in PostContent")
            self.imagePostView.isHidden = false
        }
    }

}
