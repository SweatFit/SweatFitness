//
//  SuggestionsViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/29/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var createdWorkout:PFObject?
    var suggestions = WorkoutSuggestionCollection()
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("workoutCells") as WorkoutViewCell
        let workouts = suggestions.workouts!
        let wo = workouts[indexPath.row]
        let firstName = wo.creator["firstName"] as String
        let lastName = wo.creator["lastName"] as String
        cell.nameLabel.text = "\(firstName) \(lastName)"
        //cell.timeLabel
        return cell
    }
    
    func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
