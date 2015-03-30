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
    var userWorkouts:[PFObject]?
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
                    self.userWorkouts = objs
                    for obj in objs {
                        let objid = obj.objectId
                        let requery = PFQuery(className: "WorkoutRequestObject")
                        requery.whereKey("targetWorkoutID", equalTo:objid)
                        let requests = requery.findObjects()
                        if let reqs = requests as? [PFObject] {
                            self.userRequests!.append(reqs)
                        }
                    }
                }
                self.requestTable.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userRequests != nil {
            return userRequests![section].count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if userWorkouts != nil {
            return userWorkouts!.count
        } else {
            return 0
        }
    }
}
