//
//  ComposeMenuView.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit

class ComposeMenu: UIView {
    @IBOutlet var contentView: ComposeMenu!
    @IBOutlet weak var textPostButton: UIButton!
    @IBOutlet weak var workoutPostButton: UIButton!
    @IBOutlet weak var dietPostButton: UIButton!
    @IBOutlet weak var imagePostButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ComposeMenu", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
