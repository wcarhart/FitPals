//
//  TestUserSingleton.swift
//  FitPals
//
//  Created by Will Carhart on 5/4/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import Foundation

struct TestUserSingleton {
    static var shared = TestUserSingleton()
    
    var user = User(
        name: "Will Carhart",
        picture: "demo_image",
        id: 1,
        posts: [
            Post(owner: 1, id: 1, workout: nil, pictures: nil, dietPlan: nil, text: "test post 0", date: Date())!,
            Post(owner: 1, id: 2, workout: nil, pictures: nil, dietPlan: nil, text: "test post 1", date: Date())!,
            Post(owner: 1, id: 3, workout: nil, pictures: nil, dietPlan: nil, text: "test post 2", date: Date())!
        ]
    )
}
