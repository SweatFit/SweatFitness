//
//  SuggestInviteViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class SuggestInviteViewController: UIViewController {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    var createdWorkout:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "Workout")
        query.includeKey("creator")
        query.whereKey("location", equalTo: createdWorkout!["location"])
        query.whereKey("startTime", greaterThanOrEqualTo: createdWorkout!["startTime"])
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let objs = objects as? [PFObject] {
                    
                }
            } else {
                println(error)
            }
        }
        /*
        would be using this if cloud code was working correctly
        PFCloud.callFunctionInBackground("getSuggestions", withParameters: ["location" : createdWorkout!["location"]]) { (response:AnyObject!, error:NSError!) -> Void in
                if error == nil {
                    println(response);
                } else {
                    println(error);
                }
        }*/
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}