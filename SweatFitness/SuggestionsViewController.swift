//
//  SuggestionsViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/29/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class SuggestionsViewController: UIViewController {
    var createdWorkout:PFObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        self.navigationItem.setRightBarButtonItem(doneButton, animated: false)
        let query = PFQuery(className: "Workout")
        query.includeKey("creator")
        query.whereKey("creator", notEqualTo: PFUser.currentUser())
        query.whereKey("location", equalTo: createdWorkout!["location"])
        query.whereKey("startTime", greaterThanOrEqualTo: createdWorkout!["startTime"])
        query.addAscendingOrder("startTime")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let objs = objects as? [PFObject] {
                    println(objs)
                }
            } else {
                println(error)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
