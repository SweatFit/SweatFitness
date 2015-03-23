//
//  MainWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class MainWorkoutViewController: UITableViewController {
    var workouts = WorkoutCollection()
    @IBOutlet var workoutTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className: "Workout")
        query.includeKey("creator.username")
        for gym in workouts.gyms! {
            var query = PFQuery(className: "Workout")
            query.whereKey("location", equalTo: gym)
            query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    //println("Successfully retrieved \(objects.count) workouts at \(gym)")
                    //println(objects)
                    var workouts = [Workout]()
                    if let objects = objects as? [PFObject] {
                        for obj in objects {
                            let creator: AnyObject! = obj["creator"]
                            let startTime = obj["startTime"] as NSDate
                            let endTime = obj["endTime"] as NSDate
                            let location = obj["location"] as String
                            let workout = Workout(creator: creator, startTime: startTime, endTime: endTime, location: location)
                            workouts.append(workout)
                        }
                        self.workouts.workoutDict!.updateValue(workouts, forKey: gym)
                    }
                } else {
                    println("Error: \(error) \(error.userInfo!)")
                }
                self.workoutTable.reloadData()
            })
        }
        /*
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects.count) workouts")
                self.workoutObjects = objects as? [PFObject]
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object["creator"])
                        println(object["startTime"])
                        println(object["endTime"])
                        println(object["location"])
                    }
                }
                self.workoutTable.reloadData()
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func makeWorkout(sender: AnyObject) {
        
    }
    
    @IBAction func plusPressed(sender: AnyObject, forEvent event: UIEvent) {
        let button = sender as UIControl
        let contentView = sender.superview
        let cell = contentView!?.superview
        let indexPath = self.workoutTable.indexPathForCell(cell as UITableViewCell)
        //let indexPath = self.workoutTable.indexPathForRowAtPoint(point)
        sender.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        if (indexPath != nil) {
            println(indexPath)
            self.tableView(self.workoutTable, accessoryButtonTappedForRowWithIndexPath: indexPath!)
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("request workout")
    }
    
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.workouts.gyms![section]
    }
    */
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let img = UIImage(named: "hexagon")
        let button = UIButton()
        button.setTitle(self.workouts.gyms![section], forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(img, forState: UIControlState.Normal)
        //button.setImage(img, forState: UIControlState.Normal)
        button.tag = section
        button.addTarget(self, action: Selector("headerTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    func headerTapped(sender: AnyObject) -> Void {
        if self.workouts.sectionHidden![sender.tag] {
            self.workouts.sectionHidden![sender.tag] = false
        } else {
            self.workouts.sectionHidden![sender.tag] = true
        }
        self.workoutTable.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gym = self.workouts.gyms![indexPath.section]
        let workoutForIndexPath = self.workouts.workoutDict![gym]![indexPath.row]
        let formatter = NSDateFormatter()
        let sTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.startTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        let eTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.endTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        var cell = tableView.dequeueReusableCellWithIdentifier("workoutCells") as WorkoutViewCell
        //println(cell.contentView.subviews)
        cell.nameLabel.text = "admin"
        cell.timeLabel.text = "\(sTime) - \(eTime)"
        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.workouts.gyms!.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.workouts.sectionHidden![section] {
            return 0
        } else {
            let gyms = self.workouts.gyms!
            let workoutObjs = self.workouts.workoutDict![gyms[section]]!
            return workoutObjs.count
        }
        /*
        if workoutObjs != nil {
            return
        } else {
            return 0
        }*/
    }
}
