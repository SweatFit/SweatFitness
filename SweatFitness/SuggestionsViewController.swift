//
//  SuggestionsViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/29/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BaseRequestDelegate {
    var createdWorkout:PFObject?
    var suggestions = GeneralWorkoutCollection()
    @IBOutlet weak var suggestionTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        self.navigationItem.setRightBarButtonItem(doneButton, animated: false)
        self.suggestionQuery()
    }
    
    func suggestionQuery () {
        let query = PFQuery(className: "Workout")
        query.includeKey("creator")
        query.whereKey("creator", notEqualTo: PFUser.currentUser())
        query.whereKey("location", equalTo: createdWorkout!["location"])
        let startTime = createdWorkout!["startTime"] as NSDate
        let calendar = NSCalendar.currentCalendar()
        let dateTimeFlags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
        var stComps = calendar.components(dateTimeFlags, fromDate: startTime)
        stComps.hour = stComps.hour - 1
        let minStartTime = calendar.dateFromComponents(stComps)
        stComps.hour = stComps.hour + 2
        let maxStartTime = calendar.dateFromComponents(stComps)
        query.whereKey("startTime", greaterThanOrEqualTo: createdWorkout!["startTime"])
        query.addAscendingOrder("startTime")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let objs = objects as? [PFObject] {
                    println(objs)
                    self.suggestions.populateWorkoutWithObjects(objs)
                    self.suggestionTable.reloadData()
                }
            } else {
                println(error)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggestions.workouts != nil {
            return suggestions.workouts!.count
        } else {
            return 0
        }
    }
    
    @IBAction func request(sender: UIButton) {
        let button = sender as UIControl
        let contentView = sender.superview
        let cell = contentView!.superview
        let indexPath = self.suggestionTable.indexPathForCell(cell as UITableViewCell)
        //let indexPath = self.workoutTable.indexPathForRowAtPoint(point)
        sender.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        if (indexPath != nil) {
            self.tableView(self.suggestionTable, accessoryButtonTappedForRowWithIndexPath: indexPath!)
        }
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let me = PFUser.currentUser()
        let creator = suggestions.findWorkoutCreator(accessoryButtonTappedForRowWithIndexPath: indexPath)
        let workoutID = suggestions.findWorkoutID(accessoryButtonTappedForRowWithIndexPath: indexPath)
        let request = WorkoutRequest(sourceID: me.objectId, destID: creator.objectId, targetWorkoutID: workoutID, senderName: me["additional"] as String)
        request.delegate = self
        request.makeRequest()
        println("request workout")
    }
    
    func saveRequestSuccess(success: Bool) {
        println("success")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutCells") as WorkoutViewCell
        let wo = suggestions.workouts![indexPath.row]
        let firstName = wo.creator["firstName"] as String
        let lastName = wo.creator["lastName"] as String
        cell.nameLabel.text = "\(firstName) \(lastName)"
        let sTime  = NSDateFormatter.localizedStringFromDate(wo.startTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        let eTime  = NSDateFormatter.localizedStringFromDate(wo.endTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        cell.timeLabel.text = "\(sTime) - \(eTime)"
        return cell
    }
    
    func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
