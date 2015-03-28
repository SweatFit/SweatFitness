//
//  SignUpViewController.swift
//  SweatFitness
//
//  Created by shmoop on 3/28/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import ParseUI
import Parse

class SignUpViewController : PFSignUpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpView.usernameField.placeholder = "Username (ex. fituser1)"
        self.signUpView.passwordField.placeholder = "Password (At least 8 characters)"
        self.signUpView.emailField.placeholder = "Email (ex. fitfit@u.northwestern.edu)"
        self.signUpView.additionalField.placeholder = "Full Name (ex: Fit User)"
    }
}