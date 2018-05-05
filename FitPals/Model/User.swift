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
    var picture: String?
    var posts: [Post]
    var products: [Product]
    var connections: [User]
    
    // unique identification for user
    // ~4 billion possibilities
    var id: Int32
    
    // ids of posts this user has voted for
    // key = post id
    // key = voteResult: true = upvote, false = downvote
    var votes: [Int32: Bool]
    
    init(name: String, picture: String?, id: Int32) {
        self.name = name
        self.picture = picture
        self.posts = []
        self.products = []
        self.connections = []
        self.id = id
        self.votes = [:]
    }
    
    init(name: String, picture: String?, id: Int32, posts: [Post]) {
        self.name = name
        self.picture = picture
        self.posts = posts
        self.products = []
        self.connections = []
        self.id = id
        self.votes = [:]
    }
    
    mutating func addPosts(_ posts: [Post]) {
        for post in posts {
            self.posts.append(post)
        }
    }
    
    mutating func setPhoto(named name: String) {
        self.picture = name
    }
}
