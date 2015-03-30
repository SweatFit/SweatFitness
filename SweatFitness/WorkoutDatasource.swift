//
//  Workout.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/27/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import Parse

class WorkoutSuggestionCollection:NSObject {
    var workouts:[Workout]?
    override init () {
        workouts = [Workout]()
    }
    func populateWorkoutWithObjects(objects:[PFObject]) {
        for obj in objects {
            let location = obj["location"] as String
            let creator = obj["creator"] as PFUser
            let workoutID = obj.objectId
            let startTime = obj["startTime"] as NSDate
            let endTime = obj["endTime"] as NSDate
            let workout = Workout(creator: creator, workoutID: workoutID, startTime: startTime, endTime: endTime, location: location)
            workouts!.append(workout)
        }
    }
}

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
                let workoutID = obj.objectId
                let startTime = obj["startTime"] as NSDate
                let endTime = obj["endTime"] as NSDate
                let workout = Workout(creator: creator, workoutID: workoutID, startTime: startTime, endTime: endTime, location: location)
                workouts.append(workout)
            }
            self.workoutDict?.updateValue(workouts, forKey: gym)
        }
    }
    func findWorkout(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> Workout {
        let gym = self.gyms![indexPath.section] as String
        let wos = self.workoutDict![gym]
        let wo = wos![indexPath.row]
        return wo
    }
    func findWorkoutCreator(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> PFUser {
        let wo = self.findWorkout(accessoryButtonTappedForRowWithIndexPath: indexPath)
        return wo.creator
    }
    func findWorkoutID(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> String {
        let wo = self.findWorkout(accessoryButtonTappedForRowWithIndexPath: indexPath)
        return wo.workoutID! as String
    }
    func findWorkoutStartTime(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> NSDate {
        let wo = self.findWorkout(accessoryButtonTappedForRowWithIndexPath: indexPath)
        return wo.startTime!
    }
    func findWorkoutEndTime(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> NSDate {
        let wo = self.findWorkout(accessoryButtonTappedForRowWithIndexPath: indexPath)
        return wo.startTime!
    }
    func findWorkoutLocation(accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) -> String {
        let wo = self.findWorkout(accessoryButtonTappedForRowWithIndexPath: indexPath)
        return wo.location!
    }
}

class Workout: NSObject {
    var creator:PFUser
    var workoutID:String?
    var startTime:NSDate?
    var endTime:NSDate?
    var location:String?
    
    init(creator:PFUser, workoutID:String, startTime:NSDate, endTime:NSDate, location:String) {
        self.creator = creator
        self.workoutID = workoutID
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
    }
}