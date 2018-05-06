//
//  ImageDisplayer.swift
//  FitPals
//
//  Created by Will Carhart on 5/6/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class ImageDisplayer: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var oneImageView: UIView!
    @IBOutlet weak var twoImagesView: UIView!
    @IBOutlet weak var threeImagesView: UIView!
    @IBOutlet weak var threePlusImagesView: UIView!
    
    // 1 image
    @IBOutlet weak var oneImage0: UIImageView!
    @IBOutlet weak var oneImageButton0: UIButton!
    
    // 2 images
    @IBOutlet weak var twoImages0: UIImageView!
    @IBOutlet weak var twoImages1: UIImageView!
    @IBOutlet weak var twoImagesButton0: UIButton!
    @IBOutlet weak var twoImagesButton1: UIButton!
    
    // 3 images
    @IBOutlet weak var threeImages0: UIImageView!
    @IBOutlet weak var threeImages1: UIImageView!
    @IBOutlet weak var threeImages2: UIImageView!
    @IBOutlet weak var threeImagesButton0: UIButton!
    @IBOutlet weak var threeImagesButton1: UIButton!
    @IBOutlet weak var threeImagesButton2: UIButton!
    
    // 3+ images
    @IBOutlet weak var threePlusImages0: UIImageView!
    @IBOutlet weak var threePlusImages1: UIImageView!
    @IBOutlet weak var threePlusImages2: UIImageView!
    @IBOutlet weak var threePlusImages3: UIImageView!
    @IBOutlet weak var threePlusImagesButton0: UIButton!
    @IBOutlet weak var threePlusImagesButton1: UIButton!
    @IBOutlet weak var threePlusImagesButton2: UIButton!
    @IBOutlet weak var threePlusImagesButton3: UIButton!
    @IBOutlet weak var threePlusExtraView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ImageDisplayer", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
