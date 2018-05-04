//
//  Post.swift
//  FitPals
//
//  Created by Will Carhart on 4/24/18.
//  Copyright © 2018 Will Carhart. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    var owner: User
    
    var workout: Workout?
    var pictures: [String]? // stores as urls
    var dietPlan: DietPlan?
    
    // TODO: add videos
    //var videos: type?
    
    var text: String?
    var shares: Int
    var score: Int
    
    init?(owner: User, workout: Workout?, pictures: [String]?, dietPlan: DietPlan?, text: String?) {
        if workout == nil && pictures == nil && dietPlan == nil && text == nil {
            return nil
        }
        
        self.owner = owner
        self.workout = workout
        self.pictures = pictures
        self.dietPlan = dietPlan
        self.text = text
        self.shares = 0
        self.score = 0
    }
}
