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
    // user id of post owner
    var owner: Int32
    
    // unique identification for user
    // ~4 billion possibilities
    var id: Int32
    
    var workout: Workout?
    var pictures: [String]? // stores as urls
    var dietPlan: DietPlan?
    
    // TODO: add videos
    //var videos: type?
    
    var text: String?
    var shares: Int
    
    // list of users who have voted on this post
    // key = user id
    // value = voteResult: true = upvote, false = downvote
    var votes: [Int32: Bool]
    
    var score: Int {
        return votes.reduce(0) { $0 + ($1.value ? 1 : -1) }
    }
    
    init?(owner: Int32, id: Int32, workout: Workout?, pictures: [String]?, dietPlan: DietPlan?, text: String?) {
        if workout == nil && pictures == nil && dietPlan == nil && text == nil {
            return nil
        }
        
        self.owner = owner
        self.id = id
        self.workout = workout
        self.pictures = pictures
        self.dietPlan = dietPlan
        self.text = text
        
        self.shares = 0
        self.votes = [:]
    }
}
