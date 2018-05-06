//
//  CreateNewPostViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import UIKit
import ChameleonFramework
import TextFieldEffects
import ImagePicker

enum PostType {
    case text
    case workout
    case diet
    case image
}

class CreateNewPostViewController: UIViewController, ImagePickerDelegate {
    
    // views (for colors)
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bannerView: UIView!
    
    // system outlets
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var postTitleTextField: YoshikoTextField!
    
    // text outlets
    @IBOutlet weak var textPostTextView: UITextView!
    
    // workout outlets
    
    // diet outlets
    
    // image outlets
    @IBOutlet weak var imagePostAddPhotosButton: UIButton!
    @IBOutlet weak var imagePostTextView: UITextView!
    
    var imagePicker: ImagePickerController!
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
    }
    
    var postType: PostType!
    
    var validPost: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = FlatWhiteDark()
        bannerView.backgroundColor = FlatWhiteDark()
        
        setupPostType()
        configureImagePicker()
    }
    
    func configureImagePicker() {
        var configuration = Configuration()
        if let font = UIFont(name: "Apple SD Gothic Neo Light", size: 17.0) {
            configuration.settingsFont = font
            configuration.noCameraFont = font
            configuration.numberLabelFont = font
            configuration.noImagesFont = font
        } else {
            // TODO: getting this error, needs to be fixed
            print("ERROR: could not create font")
        }
        configuration.doneButtonTitle = "Done"
        configuration.noImagesTitle = "No images found."
        configuration.recordLocation = true
        
        imagePicker = ImagePickerController(configuration: configuration)
        imagePicker.delegate = self
        imagePicker.imageLimit = 5
    }
    
    func setupPostType() {
        self.textPostTextView.isHidden = true
        // TODO: add for workout outlets
        // TODO: add for diet outlets
        self.imagePostAddPhotosButton.isHidden = true
        self.imagePostTextView.isHidden = true
        
        switch self.postType {
        case .text:
            print("LOG: text post detected")
            self.textPostTextView.isHidden = false
        case .workout:
            print("LOG: workout post detected")
        case .diet:
            print("LOG: diet post detected")
        case .image:
            print("LOG: image post detected")
            self.imagePostAddPhotosButton.isHidden = false
            self.imagePostAddPhotosButton.backgroundColor = FlatGreen()
            self.imagePostTextView.isHidden = false
        default:
            print("ERROR: couldn't detect post type")
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("LOG: cancel post button pressed")
        performSegue(withIdentifier: "unwindToFeed", sender: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("LOG: submit post button pressed")
        
        // TODO: need to upload new post to Firestore
        
        performSegue(withIdentifier: "unwindToFeed", sender: nil)
    }
    
    @IBAction func addPhotosButtonPressed(_ sender: UIButton) {
        print("LOG: add new photos button pressed")
        
        present(imagePicker, animated: true, completion: nil)
        self.imagePostAddPhotosButton.backgroundColor = FlatGreen()
    }
    
    @IBAction func addPhotosButtonDown(_ sender: UIButton) {
        self.imagePostAddPhotosButton.backgroundColor = FlatGreenDark()
    }
    
    @IBAction func addPhotosButtonUp(_ sender: UIButton) {
        self.imagePostAddPhotosButton.backgroundColor = FlatGreen()
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // TODO: finish this
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // TODO: finish this
        print("LOG: image picker returned with status 'done'")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        // TODO: finish this
        print("LOG: image picker returned with status 'cancel'")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
