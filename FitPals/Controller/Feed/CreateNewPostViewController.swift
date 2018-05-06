//
//  CreateNewPostViewController.swift
//  FitPals
//
//  Created by Will Carhart on 5/5/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

// UI
import UIKit
import ChameleonFramework
import TextFieldEffects
import PKHUD

// images
import ImagePicker
import SwiftPhotoGallery

enum PostType {
    case text
    case workout
    case diet
    case image
}

class CreateNewPostViewController: UIViewController, ImagePickerDelegate, SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource, UITextViewDelegate {
    
    // views (for colors)
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bannerView: UIView!
    
    // system outlets
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var postTitleTextField: YoshikoTextField!
    
    // text outlets
    @IBOutlet weak var textPostTextView: UITextView!
    
    // workout outlets
    // TODO: add workout outlets
    
    // diet outlets
    // TODO: add diet outlets
    
    // image outlets
    @IBOutlet weak var imagePostAddPhotosButton: UIButton!
    @IBOutlet weak var imageDisplayer: ImageDisplayer!
    @IBOutlet weak var imageDisplayerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagePostTextView: UITextView!
    
    var showImageDisplayer: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.imageDisplayerHeightConstraint.constant = self.showImageDisplayer ? 200.0 : 0.0
            }
        }
    }
    var imagePicker: ImagePickerController!
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
    }
    var didSelectPhotos: Bool = false
    
    var postType: PostType!
    var validPost: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = FlatWhiteDark()
        bannerView.backgroundColor = FlatWhiteDark()
        
        setupPostType()
        
        self.textPostTextView.delegate = self
        self.imagePostTextView.delegate = self
        // TODO: add for workout and diet posts
    }
    
    func configureImagePicker() {
        
        self.showImageDisplayer = false
        
        var configuration = Configuration()
        if let font = UIFont(name: "AppleSDGothicNeo-Light", size: 17.0) {
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
        imagePicker.imageLimit = 10
    }
    
    func setupPostType() {
        self.textPostTextView.isHidden = true
        // TODO: add for workout outlets
        // TODO: add for diet outlets
        self.imagePostAddPhotosButton.isHidden = true
        self.imageDisplayer.isHidden = true
        self.imagePostTextView.isHidden = true
        
        switch self.postType {
        case .text:
            print("LOG: text post detected")
            self.showImageDisplayer = false
            self.textPostTextView.isHidden = false
            self.textPostTextView.text = "Type your post here..."
            self.textPostTextView.textColor = FlatGray()
        case .workout:
            print("LOG: workout post detected")
        case .diet:
            print("LOG: diet post detected")
        case .image:
            print("LOG: image post detected")
            self.imagePostAddPhotosButton.isHidden = false
            self.imagePostAddPhotosButton.backgroundColor = FlatGreen()
            self.imageDisplayer.isHidden = false
            self.imageDisplayer.threePlusImages3.isHidden = true
            self.imageDisplayer.backgroundColor = FlatWhiteDark()
            self.imagePostTextView.isHidden = false
            self.imagePostTextView.text = "Type your post here..."
            self.imagePostTextView.textColor = FlatGray()
            configureImagePicker()
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
        print("LOG: wrapper did press in image picker")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        didSelectPhotos = true
        print("LOG: image picker returned with status 'done'")
        imagePicker.dismiss(animated: true, completion: nil)
        HUD.show(.progress)
        setupImageDisplayer()
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        if !didSelectPhotos {
            self.showImageDisplayer = false
        }
        print("LOG: image picker returned with status 'cancel'")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setupImageDisplayer() {
        self.showImageDisplayer = true
        
        self.imageDisplayer.oneImageView.isHidden = true
        self.imageDisplayer.twoImagesView.isHidden = true
        self.imageDisplayer.threeImagesView.isHidden = true
        self.imageDisplayer.threePlusImagesView.isHidden = true
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = FlatBlack()
        gallery.pageIndicatorTintColor = FlatGray().withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = FlatWhite()
        gallery.hidePageControl = false
        
        let photoCount = self.imageAssets.count
        switch photoCount {
        case 0:
            print("WARNING: user did select any photos")
        case 1:
            print("LOG: setting up gallery for 1 image")
            self.imageDisplayer.oneImageView.isHidden = false
            self.imageDisplayer.oneImage0.image = imageAssets[0]
            self.imageDisplayer.oneImageButton0.addTarget(self, action: #selector(oneImageButton0Pressed), for: .touchUpInside)
        case 2:
            print("LOG: setting up gallery for 2 images")
            self.imageDisplayer.twoImagesView.isHidden = false
            self.imageDisplayer.twoImages0.image = imageAssets[0]
            self.imageDisplayer.twoImages1.image = imageAssets[1]
            self.imageDisplayer.twoImagesButton0.addTarget(self, action: #selector(twoImagesButton0Pressed), for: .touchUpInside)
            self.imageDisplayer.twoImagesButton1.addTarget(self, action: #selector(twoImagesButton1Pressed), for: .touchUpInside)
        case 3:
            print("LOG: setting up gallery for 3 images")
            self.imageDisplayer.threeImagesView.isHidden = false
            self.imageDisplayer.threeImages0.image = imageAssets[0]
            self.imageDisplayer.threeImages1.image = imageAssets[1]
            self.imageDisplayer.threeImages2.image = imageAssets[2]
            self.imageDisplayer.threeImagesButton0.addTarget(self, action: #selector(threeImagesButton0Pressed), for: .touchUpInside)
            self.imageDisplayer.threeImagesButton1.addTarget(self, action: #selector(threeImagesButton1Pressed), for: .touchUpInside)
            self.imageDisplayer.threeImagesButton2.addTarget(self, action: #selector(threeImagesButton2Pressed), for: .touchUpInside)
        default:
            print("LOG: setting up gallery for 3+ images")
            self.imageDisplayer.threePlusImagesView.isHidden = false
            self.imageDisplayer.threePlusImages3.isHidden = false
            
            // TODO: fix border color, looks bad rn
            //self.imageDisplayer.threePlusExtraView.layer.borderWidth = 1
            //self.imageDisplayer.threePlusExtraView.layer.borderColor = FlatBlack().cgColor
            
            self.imageDisplayer.threePlusImages0.image = imageAssets[0]
            self.imageDisplayer.threePlusImages1.image = imageAssets[1]
            self.imageDisplayer.threePlusImages2.image = imageAssets[2]
            
            self.imageDisplayer.threePlusImagesButton0.addTarget(self, action: #selector(threePlusImagesButton0Pressed), for: .touchUpInside)
            self.imageDisplayer.threePlusImagesButton1.addTarget(self, action: #selector(threePlusImagesButton1Pressed), for: .touchUpInside)
            self.imageDisplayer.threePlusImagesButton2.addTarget(self, action: #selector(threePlusImagesButton2Pressed), for: .touchUpInside)
            self.imageDisplayer.threePlusImagesButton3.addTarget(self, action: #selector(threePlusImagesButton3Pressed), for: .touchUpInside)
        }
        HUD.flash(.success, delay: 1.0)
    }
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageAssets.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return imageAssets[forIndex]
    }
    
    @objc func oneImageButton0Pressed() {
        print("LOG: 1-image-button0 tapped")
    }
    
    @objc func twoImagesButton0Pressed() {
        print("LOG: 2-images-button0 tapped")
    }
    
    @objc func twoImagesButton1Pressed() {
        print("LOG: 2-images-button1 tapped")
    }
    
    @objc func threeImagesButton0Pressed() {
        print("LOG: 3-images-button0 tapped")
    }
    
    @objc func threeImagesButton1Pressed() {
        print("LOG: 3-images-button1 tapped")
    }
    
    @objc func threeImagesButton2Pressed() {
        print("LOG: 3-images-button2 tapped")
    }
    
    @objc func threePlusImagesButton0Pressed() {
        print("LOG: 3+-images-button0 tapped")
    }
    
    @objc func threePlusImagesButton1Pressed() {
        print("LOG: 3+-images-button1 tapped")
    }
    
    @objc func threePlusImagesButton2Pressed() {
        print("LOG: 3+-images-button2 tapped")
    }
    
    @objc func threePlusImagesButton3Pressed() {
        print("LOG: 3+-images-button3 tapped")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        switch self.postType {
        case .text:
            if self.textPostTextView.textColor == FlatGray() {
                self.textPostTextView.text = ""
                self.textPostTextView.textColor = FlatBlack()
            }
        case .image:
            if self.imagePostTextView.textColor == FlatGray() {
                self.imagePostTextView.text = ""
                self.imagePostTextView.textColor = FlatBlack()
            }
        default:
            // add for workout and diet posts
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        switch self.postType {
        case .text:
            if self.textPostTextView.text == "" {
                self.textPostTextView.text = "Type your post here..."
                self.textPostTextView.textColor = FlatGray()
            }
        case .image:
            if self.imagePostTextView.text == "" {
                self.imagePostTextView.text = "Type your post here..."
                self.imagePostTextView.textColor = FlatGray()
            }
        default:
            // add for workout and diet posts
            break
        }
 
    }
    
    
    
    
    
    
    
    
    
}
