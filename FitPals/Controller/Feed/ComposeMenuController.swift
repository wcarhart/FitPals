//
//  ComposeMenu.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol ComposeMenuDelegate {
    func updateParent(with postType: PostType)
}

class ComposeMenuController: NSObject {
    
    var delegate: ComposeMenuDelegate?
    
    let background = UIView()
    let menuContainer = UIView()
    
    func showComposeMenu() {
        if let window = UIApplication.shared.keyWindow {
            // dim background
            background.backgroundColor = UIColor(white: 0, alpha: 0.5)
            background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideComposeMenu)))
            background.frame = window.frame
            background.alpha = 0
            
            // add subviews
            window.addSubview(background)
            window.addSubview(menuContainer)
            
            // set up menu container
            let height: CGFloat  = 350
            let y = window.frame.height - height
            menuContainer.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            menuContainer.backgroundColor = FlatWhite()
            
            // set up menu view
            let composeMenu = ComposeMenu()
            menuContainer.addSubview(composeMenu)
            composeMenu.translatesAutoresizingMaskIntoConstraints = false
            composeMenu.topAnchor.constraint(equalTo: menuContainer.topAnchor, constant: 0).isActive = true
            composeMenu.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor, constant: 0).isActive = true
            composeMenu.bottomAnchor.constraint(equalTo: menuContainer.bottomAnchor, constant: 0).isActive = true
            composeMenu.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor, constant: 0).isActive = true
            composeMenu.contentView.backgroundColor = FlatWhite()
            
            // text button
            composeMenu.textPostButton.layer.cornerRadius = 0.5 * composeMenu.textPostButton.bounds.size.width
            composeMenu.textPostButton.backgroundColor = FlatOrange()
            composeMenu.textPostButton.addTarget(self, action: #selector(addTextPost), for: .touchUpInside)
            
            // workout button
            composeMenu.workoutPostButton.layer.cornerRadius = 0.5 * composeMenu.workoutPostButton.bounds.size.width
            composeMenu.workoutPostButton.backgroundColor = FlatOrange()
            composeMenu.workoutPostButton.addTarget(self, action: #selector(addWorkoutPost), for: .touchUpInside)
            
            // diet button
            composeMenu.dietPostButton.layer.cornerRadius = 0.5 * composeMenu.dietPostButton.bounds.size.width
            composeMenu.dietPostButton.backgroundColor = FlatOrange()
            composeMenu.dietPostButton.addTarget(self, action: #selector(addDietPost), for: .touchUpInside)
            
            // image button
            composeMenu.imagePostButton.layer.cornerRadius = 0.5 * composeMenu.imagePostButton.bounds.size.width
            composeMenu.imagePostButton.backgroundColor = FlatOrange()
            composeMenu.imagePostButton.addTarget(self, action: #selector(addImagePost), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.background.alpha = 1
                self.menuContainer.frame = CGRect(x: 0, y: y, width: self.menuContainer.frame.width, height: self.menuContainer.frame.height)
            }, completion: nil)
            
        }
    }
    
    @objc func addTextPost() {
        print("LOG: add text post")
        hideComposeMenu()
        delegate?.updateParent(with: .text)
    }
    
    @objc func addWorkoutPost() {
        print("LOG: add workout post")
        hideComposeMenu()
        delegate?.updateParent(with: .workout)
    }
    
    @objc func addDietPost() {
        print("LOG: add diet post")
        hideComposeMenu()
        delegate?.updateParent(with: .diet)
    }
    
    @objc func addImagePost() {
        print("LOG: add image post")
        hideComposeMenu()
        delegate?.updateParent(with: .image)
    }
    
    @objc func hideComposeMenu() {
        
        UIView.animate(withDuration: 0.5) {
            self.background.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.menuContainer.frame = CGRect(x: 0, y: window.frame.height, width: self.menuContainer.frame.width, height: self.menuContainer.frame.height)
            }
        }
    }
}
