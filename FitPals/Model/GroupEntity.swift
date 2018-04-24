//
//  GroupEntity.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import Foundation

struct GroupEntity {
    var owner: User
    var members: [User]
    var posts: [Post]
    var products: [Product]
    var isPublic: Bool
}
