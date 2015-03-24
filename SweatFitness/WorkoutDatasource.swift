//
//  Workout.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/27/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation

class WorkoutCollection {
    var workoutDict:[String:[Workout]]?
    var sectionHidden:[Bool]?
    var gyms:[String]?
    init () {
        gyms = ["SPAC", "Blomquist", "Patten"]
        sectionHidden = [false, false, false]
        workoutDict = ["SPAC":[Workout](), "Blomquist":[Workout](), "Patten":[Workout]()]
    }
}

class Workout {
    var creator:AnyObject?
    var startTime:NSDate?
    var endTime:NSDate?
    var location:String?
    
    init(creator:AnyObject, startTime:NSDate, endTime:NSDate, location:String) {
        self.creator = creator
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
    }
}