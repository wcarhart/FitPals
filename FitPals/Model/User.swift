//
//  User.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import Foundation

struct User {
    var posts: [Post]
    var products: [Product]
    var connections: [User]
    
    init() {
        posts = []
        products = []
        connections = []
    }
    
    init(posts: [Post], products: [Product], connections: [User]) {
        self.posts = posts
        self.products = products
        self.connections = connections
    }
}
