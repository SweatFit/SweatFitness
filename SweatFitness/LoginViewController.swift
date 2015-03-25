//
//  LoginViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/23/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//
/*
func logInViewController(logInController: PFLogInViewController!,
    didLogInUser user: PFUser!)
{
    var nextViewController = RegisterViewController()
    self.presentViewController(nextViewController, animated: true, completion: nil)
}

class LoginViewController: PFLogInViewController, PFLogInViewControllerDelegate, FBLoginViewDelegate, PFSignUpViewControllerDelegate {
    var usernameTF: UITextField?
    var passwordTF: UITextField?
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
    
    @IBAction func login(sender: AnyObject) {
        println(usernameTF!.text)
        println(passwordTF!.text)
        PFUser.logInWithUsernameInBackground(usernameTF!.text, password: passwordTF!.text) { (userObj: PFUser!, error: NSError!) -> Void in
            if userObj == nil {
                println(error)
            } else {
                println(userObj)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let unamecell = tableView.dequeueReusableCellWithIdentifier("usernameCell") as UITableViewCell
            self.usernameTF = unamecell.contentView.viewWithTag(1) as UITextField?
            self.usernameTF!.delegate = self
            return unamecell
        } else {
            let pwdcell = tableView.dequeueReusableCellWithIdentifier("passwordCell") as UITableViewCell
            self.passwordTF = pwdcell.contentView.viewWithTag(1) as UITextField?
            self.passwordTF!.delegate = self
            return pwdcell
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
}
*/


