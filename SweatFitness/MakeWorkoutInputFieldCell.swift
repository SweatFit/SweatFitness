//
//  MakeWorkoutInputFieldCell.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/24/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit

class MakeWorkoutInputPickerFieldCell: UITableViewCell {
    
    @IBOutlet weak var fieldname: UILabel!
    @IBOutlet weak var inputTF: MyTextField!
}

class MakeWorkoutInputTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var fieldname: UILabel!
    @IBOutlet weak var inputTF: UITextField!
}

class MyTextField: UITextField {
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        UIMenuController.sharedMenuController().menuVisible = false
        self.selectedTextRange = nil
        let selname = sel_getName(action)
        if selname == "paste:" {
            return false
        } else if selname == "copy:" {
            return false
        } else if selname == "cut:" {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero
    }
}