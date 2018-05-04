//
//  User.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var name: String
    var picture: UIImage?
    var posts: [Post]
    var products: [Product]
    var connections: [User]
    
    init() {
        self.name = ""
        self.posts = []
        self.products = []
        self.connections = []
    }
    
    init(named name: String) {
        self.name = name
        self.posts = []
        self.products = []
        self.connections = []
    }
    
    init(name: String, posts: [Post], products: [Product], connections: [User]) {
        self.name = name
        self.posts = posts
        self.products = products
        self.connections = connections
    }
    
    mutating func addPosts(_ posts: [Post]) {
        for post in posts {
            self.posts.append(post)
        }
    }
}
