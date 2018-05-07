//
//  PostContent.swift
//  FitPals
//
//  Created by Will Carhart on 5/6/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework

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
    // TODO: add for workout
    
    // diet
    // TODO: add for diet
    
    // image
    // 4
    @IBOutlet weak var fourImagesView: UIView!
    @IBOutlet weak var fourImagesTopLeftView: UIView!
    @IBOutlet weak var fourImagesTopRightView: UIView!
    @IBOutlet weak var fourImagesBottomLeftView: UIView!
    @IBOutlet weak var fourImagesBottomRightView: UIView!
    @IBOutlet weak var fourImagesTopLeftImage: UIImageView!
    @IBOutlet weak var fourImagesTopRightImage: UIImageView!
    @IBOutlet weak var fourImagesBottomLeftImage: UIImageView!
    @IBOutlet weak var fourImagesBottomRightImage: UIImageView!
    @IBOutlet weak var fourImagesLabel: UILabel!
    
    // 8
    @IBOutlet weak var eightImagesView: UIView!
    @IBOutlet weak var eightImagesTop0View: UIView!
    @IBOutlet weak var eightImagesTop1View: UIView!
    @IBOutlet weak var eightImagesTop2View: UIView!
    @IBOutlet weak var eightImagesTop3View: UIView!
    @IBOutlet weak var eightImagesBottom0View: UIView!
    @IBOutlet weak var eightImagesBottom1View: UIView!
    @IBOutlet weak var eightImagesBottom2View: UIView!
    @IBOutlet weak var eightImagesBottom3View: UIView!
    @IBOutlet weak var eightImagesTop0Image: UIImageView!
    @IBOutlet weak var eightImagesTop1Image: UIImageView!
    @IBOutlet weak var eightImagesTop2Image: UIImageView!
    @IBOutlet weak var eightImagesTop3Image: UIImageView!
    @IBOutlet weak var eightImagesBottom0Image: UIImageView!
    @IBOutlet weak var eightImagesBottom1Image: UIImageView!
    @IBOutlet weak var eightImagesBottom2Image: UIImageView!
    @IBOutlet weak var eightImagesBottom3Image: UIImageView!
    @IBOutlet weak var eightImagesLabel: UILabel!
    
    private var postType: PostType!
    private var useFourImages: Bool = true
    
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
    
    func setNumberOfImages(to count: Int) {
        if count == 4 {
            self.useFourImages = true
        } else if count == 8 {
            self.useFourImages = false
        } else {
            print("ERROR: parameter of call to 'setNumberOfImages()' must be either 4 or 8")
            fatalError()
        }
        updatePostType()
    }
    
    func calculateHeight() -> CGFloat {
        guard let postType = self.postType else {
            print("ERROR: did not set postType for PostContent view. You must call the 'setPostType(to:)' method before using this class")
            fatalError()
        }
        
        // starts at 20 to account for padding (10 on each side, so 10x2 for top and bottom)
        var height: CGFloat = 20.0
        
        // TODO: debug this, I fear the numbers may not be quite right for height of labels
        switch postType {
        case .text:
            print("LOG: calculating height for text post")
            height += 22.0 * CGFloat(countLabelLines(label: self.textPostLabel))
        case .workout:
            print("LOG: calculating height for workout post")
            // TODO: update this
            height += 600.0
        case .diet:
            print("LOG: calculating height for diet post")
            // TODO: update this
            height += 600.0
        case .image:
            print("LOG: calculating height for image post")
            if self.useFourImages {
                height += self.fourImagesTopLeftImage.bounds.height * 2
                height += 20
                height += 22.0 * CGFloat(countLabelLines(label: self.fourImagesLabel))
            } else {
                
                // TODO: height not calculating correctly
                height += self.eightImagesTop0Image.bounds.height * 2
                height += 20
                height += 22.0 * CGFloat(countLabelLines(label: self.eightImagesLabel))
            }
        }
        
        return height
    }
    
    func countLabelLines(label: UILabel) -> Int {
        let myText = label.text! as NSString
        
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: label.font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    private func updatePostType() {
        guard let postType = self.postType else {
            print("ERROR: did not set postType for PostContent view. You must call the 'setPostType(to:)' method before using this class")
            fatalError()
        }
        
        self.textPostView.isHidden = true
        self.workoutPostView.isHidden = true
        self.dietPostView.isHidden = true
        self.imagePostView.isHidden = true
        
        self.fourImagesView.isHidden = true
        self.eightImagesView.isHidden = true
        
        switch postType {
        case .text:
            print("LOG: text post detected in PostContent")
            self.textPostView.isHidden = false
            self.textPostLabel.sizeToFit()
            self.textPostLabel.textAlignment = .left
            self.textPostLabel.numberOfLines = 0
            self.textPostLabel.textColor = FlatBlackDark()
            self.textPostLabel.text = ""
        case .workout:
            print("LOG: workout post detected in PostContent")
            self.workoutPostView.isHidden = false
        case .diet:
            print("LOG: diet post detected in PostContent")
            self.dietPostView.isHidden = false
        case .image:
            print("LOG: image post detected in PostContent")
            self.imagePostView.isHidden = false
            if self.useFourImages {
                self.fourImagesView.isHidden = false
                self.fourImagesLabel.sizeToFit()
                self.fourImagesLabel.textAlignment = .left
                self.fourImagesLabel.numberOfLines = 0
                self.fourImagesLabel.textColor = FlatBlackDark()
                self.fourImagesLabel.text = ""
            } else {
                self.eightImagesView.isHidden = false
                self.eightImagesLabel.sizeToFit()
                self.eightImagesLabel.textAlignment = .left
                self.eightImagesLabel.numberOfLines = 0
                self.eightImagesLabel.textColor = FlatBlackDark()
                self.eightImagesLabel.text = ""
            }
        }
    }
    
    func setImages(with images: [UIImage]) {
        guard images.count > 0 else { print("WARNING: can not configure images with empty image array"); return}
        if useFourImages {
            self.fourImagesTopLeftImage.image = images[0]
            self.fourImagesTopRightImage.image = images.count >= 2 ? images[1] : nil
            self.fourImagesBottomLeftImage.image = images.count >= 3 ? images[2] : nil
            self.fourImagesBottomRightImage.image = images.count >= 4 ? images[3] : nil
        } else {
            self.eightImagesTop0Image.image = images[0]
            self.eightImagesTop1Image.image = images.count >= 2 ? images[1] : nil
            self.eightImagesTop2Image.image = images.count >= 3 ? images[2] : nil
            self.eightImagesTop3Image.image = images.count >= 4 ? images[3] : nil
            self.eightImagesBottom0Image.image = images.count >= 5 ? images[4] : nil
            self.eightImagesBottom1Image.image = images.count >= 6 ? images[5] : nil
            self.eightImagesBottom2Image.image = images.count >= 7 ? images[6] : nil
            self.eightImagesBottom3Image.image = images.count >= 8 ? images[7] : nil
        }
    }

}
