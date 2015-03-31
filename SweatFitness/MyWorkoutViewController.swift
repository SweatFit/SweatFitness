//
//  MyWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/30/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class MyWorkoutViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var userWorkouts = GeneralWorkoutCollection()
    var userRequests:[[PFObject]]?
    
    @IBOutlet weak var requestTable: UITableView!
    func getReqs() {
        let woquery = PFQuery(className: "Workout")
        userRequests = [[PFObject]]()
        let now = NSDate()
        woquery.whereKey("creator", equalTo: PFUser.currentUser())
        woquery.whereKey("startTime", greaterThanOrEqualTo: now)
        woquery.addAscendingOrder("startTime")
        woquery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if objects != nil {
                if let objs = objects as? [PFObject] {
                    self.userWorkouts.populateWorkoutWithObjects(objs)
                    let requery = PFQuery(className: "WorkoutRequestObject")
                    requery.whereKey("receiverID", equalTo: PFUser.currentUser().objectId)
                    requery.findObjectsInBackgroundWithBlock({ (reqobjects:[AnyObject]!, error:NSError!) -> Void in
                        if reqobjects != nil {
                            if let reqobjs = reqobjects as? [PFObject] {
                                for obj in self.userWorkouts.workouts! {
                                    let objid  = obj.workoutID
                                    let filteredarr = filter(reqobjs, {$0["targetWorkoutID"] as? String == objid})
                                    self.userRequests!.append(filteredarr)
                                }
                                self.requestTable.reloadData()
                            }
                        } else {
                            println(error)
                        }
                    })
                }
            } else {
                println(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReqs()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as RequestCell
        cell.nameLabel.text = userRequests![indexPath.section][indexPath.row]["senderName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let workoutForIndexPath = self.userWorkouts.workouts![section]
        let width = self.view.bounds.width
        let hdrview = UIView(frame: CGRectMake(0, 0, width, 60))
        let locLabel = UILabel(frame: CGRectMake(5, 5, width/2, 15))
        let timeLabel = UILabel(frame: CGRectMake(10, 30, width, 15))
        locLabel.text = "At \(workoutForIndexPath.location!)"
        locLabel.textColor = UIColor(red: 229/255, green: 86/255, blue: 58/255, alpha: 1.0)
        let sTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.startTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        let eTime  = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.endTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        let date = NSDateFormatter.localizedStringFromDate(workoutForIndexPath.startTime!, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        timeLabel.text = "from \(sTime) to \(eTime) on \(date)"
        timeLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        timeLabel.font = UIFont(name: "System", size: 10)
        hdrview.addSubview(locLabel)
        hdrview.addSubview(timeLabel)
        return hdrview
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userRequests != nil {
            return userRequests![section].count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if userWorkouts.workouts != nil {
            return userWorkouts.workouts!.count
        } else {
            return 0
        }
    }
}
