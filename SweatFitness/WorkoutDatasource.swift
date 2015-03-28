//
//  Workout.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/27/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import Parse

class WorkoutCollection {
    var workoutDict:[String:[Workout]]?
    var sectionHidden:[Bool]?
    var gyms:[String]?
    init () {
        gyms = ["SPAC", "Blomquist", "Patten"]
        sectionHidden = [false, false, false]
        workoutDict = ["SPAC":[Workout](), "Blomquist":[Workout](), "Patten":[Workout]()]
    }
    
    func populateWorkoutWithObjects(objects:[PFObject]) {
        for gym in gyms! {
            var workouts = [Workout]()
            let filteredarr = objects.filter({ $0["location"] as String == gym})
            for obj in filteredarr {
                let location = obj["location"] as String
                let creator = obj["creator"] as PFUser
                let startTime = obj["startTime"] as NSDate
                let endTime = obj["endTime"] as NSDate
                let workout = Workout(creator: creator, startTime: startTime, endTime: endTime, location: location)
                workouts.append(workout)
            }
            self.workoutDict?.updateValue(workouts, forKey: gym)
        }
    }
}

class Workout {
    var creator:PFUser
    var startTime:NSDate?
    var endTime:NSDate?
    var location:String?
    
    init(creator:PFUser, startTime:NSDate, endTime:NSDate, location:String) {
        self.creator = creator
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
    }
}