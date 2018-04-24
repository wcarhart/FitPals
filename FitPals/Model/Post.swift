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
    var workout: Workout
    var pictures: [UIImage]
    var dietPlan: DietPlan
    
    // TODO: add videos
    //var videos: type?
    
    var text: String
    var shares: Int
    var score: Int
}
