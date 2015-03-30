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
        self.view.backgroundColor = UIColor.purpleColor() // TODO: Change Color later
        
        let logoView = UIImageView(image: UIImage(named: "logo")) // TODO: Fix dimensions
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        self.logInView.logo = logoView
        self.delegate = self
       /* self.fields = (PFLogInFieldsUsernameAndPassword
            | PFLogInFieldsFacebook
            | PFLogInFieldsTwitter);*/
        
        
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
        let emailComps = split(email, {$0 == "@"}, allowEmptySlices: false)
        var errMessage = ""
        
        
        // Password Sanity Check
        if (password.utf16Count < 8) {
            errMessage = "Your password must be 8 characters or longer"
            valid = false
        }
        
        // Email check
        if !(email.hasSuffix("northwestern.edu") && emailComps.count == 2) {
            println("User is trying to bullshit")
            errMessage = "You must use northwestern.edu email"
            valid = false
        }
        
        // Firstname, lastname check
            
        if (valid) {
            return true
        } else {
            let alertView = UIAlertView(title: "Sign-up failed", message: errMessage, delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            return false
        }
    }
    
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        println("login success")
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("loginMainSegue", sender: self)
    }
    
}



