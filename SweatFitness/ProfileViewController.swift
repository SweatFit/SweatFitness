//
//  ProfileViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/30/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 44
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("ppicCell", forIndexPath: indexPath) as ProfPicCell
            let firstName = PFUser.currentUser()["firstName"] as String
            let lastName = PFUser.currentUser()["lastName"] as String
            (cell as ProfPicCell).namelabel.text = "\(firstName) \(lastName)"
            (cell as ProfPicCell).picView.image = UIImage(named: "profile")
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("myWorkoutCell", forIndexPath: indexPath) as? UITableViewCell
        default:
            println("new profile row")
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        switch indexPath.row {
        case 0:
            //change profile picture? action sheet for taking/uploading pictures
            return
        case 1:
            self.performSegueWithIdentifier("myWorkoutSegue", sender: self)
        default:
            return
        }
    }
}
