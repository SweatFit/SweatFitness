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
    
    var createdWorkout:PFObject?
    var segmentsController:SegmentsController?
    var segmentedControl:UISegmentedControl?
    
    func firstUserExperience() {
        self.segmentedControl!.selectedSegmentIndex = 0
        self.segmentsController!.indexDidChangeForSegmentedControl(self.segmentedControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        let suggestInviteStoryboard = UIStoryboard(name: "SuggestInvite", bundle: NSBundle.mainBundle())
        let suggestvc = suggestInviteStoryboard.instantiateViewControllerWithIdentifier("SuggestionsViewController") as SuggestionsViewController
        suggestvc.createdWorkout = self.createdWorkout
        let invitevc = suggestInviteStoryboard.instantiateViewControllerWithIdentifier("InviteViewController") as InviteViewController
        
        self.segmentsController = SegmentsController(aNavigationController: self.navigationController!, viewControllers: [suggestvc, invitevc], rootViewController: self)
        self.segmentedControl = UISegmentedControl(items: ["Suggestions", "Invite"])
        self.segmentedControl!.addTarget(self.segmentsController, action: "indexDidChangeForSegmentedControl:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.firstUserExperience()
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