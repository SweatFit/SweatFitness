//
//  InviteViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/30/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "done")
        self.navigationItem.setRightBarButtonItem(doneButton, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func done() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
