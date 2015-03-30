//
//  MainWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class MainWorkoutViewController: UITableViewController, BaseRequestDelegate {
    var workouts = WorkoutCollection()
    @IBOutlet var workoutTable: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshWorkouts()
    }
    
    func refreshWorkouts () {
        let now = NSDate()
        var query = PFQuery(className: "Workout")
        query.includeKey("creator")
        query.whereKey("startTime", greaterThan: now)
        //query.whereKey("taken", equalTo: false)
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let objs = objects as? [PFObject] {
                    println(objs)
                    self.workouts.populateWorkoutWithObjects(objs)
                }
                self.workoutTable.reloadData()
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshWorkouts()
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
            self.tableView(self.workoutTable, accessoryButtonTappedForRowWithIndexPath: indexPath!)
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let me = PFUser.currentUser()
        let creator = workouts.findWorkoutCreator(accessoryButtonTappedForRowWithIndexPath: indexPath)
        let workoutID = workouts.findWorkoutID(accessoryButtonTappedForRowWithIndexPath: indexPath)
        let request = WorkoutRequest(sourceID: me.objectId, destID: creator.objectId, targetWorkoutID: workoutID)
        request.delegate = self
        request.makeRequest()
        println("request workout")
        
    }
    
    func saveRequestSuccess(success: Bool) {
        println("Success")
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let img = UIImage(named: "hexagon")
        let button = UIButton()
        button.setTitle(self.workouts.gyms![section], forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 229/255, green: 86/255, blue: 58/255, alpha: 1.0), forState: UIControlState.Normal)
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
        let creator = workoutForIndexPath.creator
        let firstName = creator["firstName"] as String
        let lastName = creator["lastName"] as String
        let sTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.startTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        let eTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.endTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        var cell = tableView.dequeueReusableCellWithIdentifier("workoutCells") as WorkoutViewCell
        //println(cell.contentView.subviews)
        cell.nameLabel.text = "\(firstName) \(lastName)"
        cell.timeLabel.text = "\(sTime) - \(eTime)"
        if creator.objectId == PFUser.currentUser().objectId {
            cell.requestButton.hidden = true
            cell.requestButton.userInteractionEnabled = false
        }
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
