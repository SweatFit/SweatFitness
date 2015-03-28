//
//  LoginViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/23/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import ParseUI
import Parse

class LoginViewController: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor() // TODO: Change Color later
        
        let logoView = UIImageView(image: UIImage(named: "logo")) // TODO: Fix dimensions
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        self.logInView.logo = logoView
        self.delegate = self
        self.signUpController = SignUpViewController();
        
        signUpController.fields = (PFSignUpFields.UsernameAndPassword
            | PFSignUpFields.SignUpButton
            | PFSignUpFields.Email
            | PFSignUpFields.Additional
            | PFSignUpFields.DismissButton)
        println(self.signUpController)
        
        self.signUpController.delegate = self
        //self.logInView.logo.frame = CGRectMake(20, 20, 120, 120)
    
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        println("in signup success")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        //println(info["email"])
        var valid = true
        let email = info["email"] as String
        let password = info["password"] as String
        let emailComps = split(email, ($0 = "@", allowEmptySlices: false)
        var errMessage
        
        
        // Password Sanity Check
        if (password.utf16Count >= 8) {
            errMessage = "Your password must be 8 characters or longer"
            valid = false
        }
        
        
        if !(email.hasSuffix("northwestern.edu") || email. {
            errMessage = "You must use northwestern.edu email"
            valid = false
        }
        
        else {
            let alertView = UIAlertView(title: "Sign-up failed", message: "You must use u.northwestern.edu email", delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            return false
        }
        // TODO: Check password for check
        
        //return false
    }
    
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        println("login success")
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("loginMainSegue", sender: self)
    }
    
    //TODO 
    /*
        1. Check for u.northwestern.
        2. FB Signup Enable
        3. More Field for Signup (First name, Last name,
    */
    
    /*
    var usernameTF: UITextField?
    var passwordTF: UITextField?
    
    override func viewDidDisappear(animated: Bool) {
        var logInController:LoginViewController  = LoginViewController()
        logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.Facebook
            | PFLogInFields.Twitter
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten
            | PFLogInFields.DismissButton
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var logInController:LoginViewController  = LoginViewController()
        logInController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.Facebook
            | PFLogInFields.Twitter
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten
            | PFLogInFields.DismissButton
        )
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
    */
}



