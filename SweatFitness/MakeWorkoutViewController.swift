//
//  MakeWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit
import Parse

class MakeWorkoutViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    var formModel:MakeWorkoutFormModel?
    var savedWorkoutObj:PFObject?
    var gyms = ["SPAC","Blomquist","Patten"]
    var currentTF:UITextField?
    var tap:UITapGestureRecognizer?
    @IBOutlet weak var inputForm: UITableView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        formModel = MakeWorkoutFormModel()
        //println(NSDateFormatter.localizedStringFromDate(startDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        //println(NSDateFormatter.localizedStringFromDate(endDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        tap = UITapGestureRecognizer(target: self, action: "cancelPicking")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func next() {
        //TODO: implement this
        //validate user-input data
        let exception = formModel!.validateFormModel()
        if exception.isInvalid! == false {
            //if it's valid
            //make async request (or sync?)
            let newWorkoutObj = PFObject(className: "Workout")
            newWorkoutObj["startTime"] = formModel!.startDateTime!
            newWorkoutObj["endTime"] = formModel!.endDateTime!
            newWorkoutObj["location"] = formModel!.selectedGym!
            newWorkoutObj["tags"] = formModel!.Tags!
            // not yet implemented
            newWorkoutObj["creator"] = PFUser.currentUser()
            // show activity indicator
            actIndicator.hidden = false
            actIndicator.startAnimating()
            newWorkoutObj.saveInBackgroundWithBlock({ (success: Bool, error:NSError!) -> Void in
                if (success) {
                    //stop acitivity indicator and perform segue
                    self.actIndicator.hidden = true
                    self.actIndicator.stopAnimating()
                    self.savedWorkoutObj = newWorkoutObj
                    self.performSegueWithIdentifier("suggestInviteSegue", sender: nil)
                } else {
                    println(error)
                }
            })
            
        } else {
            let alertView = UIAlertView(title: "Something's wrong...", message: exception.errorMessage, delegate: self, cancelButtonTitle: "Ok")
            alertView.show()
            //alert user here. 
            //on screen alert (red marks) on input fields
            //should be dynamically shown to the user as they input
            //so call validateFormModel() every time user inputs a piece of data?
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "suggestInviteSegue" {
            let vc = segue.destinationViewController as SuggestInviteViewController
            vc.createdWorkout = self.savedWorkoutObj
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // UITableViewDelegate methods
    //////////////////////////////////////////////////////////////////////////////////
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let textLabel = UILabel()
        textLabel.font = UIFont(name: "System", size: 25)
        textLabel.text = self.formModel!.fieldSections![section]
        textLabel.textColor = UIColor(red: 229/255, green: 86/255, blue: 58/255, alpha: 1.0)
        return textLabel
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formModel!.fieldNames![section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        let section = indexPath.section
        let row = indexPath.row
        var pickerView:UIView?
        var toolbar:UIToolbar?
        switch section {
        case 0:
            
            let reuseCell = tableView.dequeueReusableCellWithIdentifier("inputPickerFieldCell") as MakeWorkoutInputPickerFieldCell
            reuseCell.fieldname.text = self.formModel!.fieldNames![section][row]
            reuseCell.fieldname.textColor = UIColor(red: 69/255, green: 185/255, blue: 193/255, alpha: 1.0)
            var pickerView:UIView?
            var toolbar:UIToolbar?
            
            pickerView = UIDatePicker()
            toolbar = UIToolbar(frame: CGRectMake(0, -40, tableView.superview!.bounds.width, 40))
            let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
            toolbar!.setItems([cancelButton, flex], animated: true)
            var doneButton:UIBarButtonItem?
            switch row {
            case 0:
                (pickerView as UIDatePicker).datePickerMode = UIDatePickerMode.Date
                (pickerView as UIDatePicker).minimumDate = formModel!.now!
                doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingDate")
                reuseCell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.now!, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            case 1:
                (pickerView as UIDatePicker).datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                reuseCell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.startDateTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            case 2:
                (pickerView as UIDatePicker).datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                (pickerView as UIDatePicker).date = formModel!.endDateTime!
                doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                reuseCell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.endDateTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            default:
                println("implement new field case")
            }
            toolbar!.items!.append(doneButton!)
            reuseCell.inputTF.inputView = pickerView
            reuseCell.inputTF.inputAccessoryView = toolbar
            cell = reuseCell
        case 1:
            
            let reuseCell = tableView.dequeueReusableCellWithIdentifier("inputPickerFieldCell") as MakeWorkoutInputPickerFieldCell
            reuseCell.fieldname.text = self.formModel!.fieldNames![section][row]
            reuseCell.fieldname.textColor = UIColor(red: 69/255, green: 185/255, blue: 193/255, alpha: 1.0)
            
            pickerView = UIPickerView()
            (pickerView as UIPickerView).delegate = self
            (pickerView as UIPickerView).dataSource = self
            toolbar = UIToolbar(frame: CGRectMake(0, -40, tableView.superview!.bounds.width, 40))
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingGym")
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
            let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            toolbar!.setItems([cancelButton, flex, doneButton], animated: true)
            reuseCell.inputTF.inputView = pickerView
            reuseCell.inputTF.inputAccessoryView = toolbar
            reuseCell.inputTF.placeholder = "Select Gym..."
            cell = reuseCell
        case 2:
            let reuseCell = tableView.dequeueReusableCellWithIdentifier("inputTextFieldCell") as MakeWorkoutInputTextFieldCell
            reuseCell.fieldname.text = self.formModel!.fieldNames![section][row]
            reuseCell.fieldname.textColor = UIColor(red: 69/255, green: 185/255, blue: 193/255, alpha: 1.0)
            reuseCell.inputTF.placeholder = "example: #chest"
            cell = reuseCell
        default:
            println("implement new section case")
        }
        
        return cell!
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // UIPickerViewDelegate, UIPickerViewDatasource methods
    ////////////////////////////////////////////////////////////////////////////////////////////
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gyms.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return gyms[row]
    }
    
    /////////////////////////////////////////////////////////////////////////
    // UITextFieldDelegate methods
    /////////////////////////////////////////////////////////////////////////
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTF = textField
        if let mytf = textField as? MyTextField {
            return
        } else {
            self.view.addGestureRecognizer(tap!)
            self.inputForm.addGestureRecognizer(tap!)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.currentTF = nil
        if let mytf = textField as? MyTextField {
            return
        } else {
            self.view.removeGestureRecognizer(tap!)
            self.inputForm.removeGestureRecognizer(tap!)
            formModel!.extractTagsFromString(textField.text)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    // actions for toolbar items
    ////////////////////////////////////////////////////////////////////////
    func donePickingDate() {
        println("donePickingDate")
        let datePicker = self.currentTF!.inputView as UIDatePicker
        formModel!.donePickingDateFromPicker(datePicker)
        currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        currentTF!.endEditing(true)
        //self.currentTF!.resignFirstResponder()
    }
    func cancelPicking() {
        currentTF!.endEditing(true)
        //self.currentTF!.resignFirstResponder()
    }
    
    func donePickingTime() {
        let indexPath = inputForm.indexPathForCell(self.currentTF!.superview!.superview as MakeWorkoutInputPickerFieldCell)
        let datePicker = self.currentTF!.inputView as UIDatePicker
        formModel!.donePickingTimeFromPicker(datePicker, withIndexPath: indexPath)
        self.currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        currentTF!.endEditing(true)
        //self.currentTF!.resignFirstResponder()
    }
    
    func donePickingGym() {
        formModel!.selectedGym = gyms[(currentTF!.inputView as UIPickerView).selectedRowInComponent(0)]
        currentTF!.text = formModel!.selectedGym
        currentTF!.endEditing(true)
        //currentTF!.resignFirstResponder()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    // keyboard notifications
    /////////////////////////////////////////////////////////////////////////////////////
    
    func keyboardWasShown(aNotification:NSNotification!) {
        println("keyboardWasShown")
        let info = aNotification.userInfo
        let kbSize = info![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue().size
        let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        inputForm.contentInset = contentInsets
        inputForm.scrollIndicatorInsets = contentInsets
        
        let aRect = CGRectMake(inputForm.frame.minX, inputForm.frame.minY, inputForm.frame.width, inputForm.frame.height-kbSize.height)
        if !CGRectContainsPoint(aRect, currentTF!.frame.origin) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.inputForm.scrollRectToVisible(self.currentTF!.frame, animated: true)
            })
        }
    }
    func keyboardWillBeHidden(aNotification:NSNotification!) {
        println("keyboardWillBeHidden")
        let contentInsets = UIEdgeInsetsZero
        inputForm.contentInset = contentInsets
        inputForm.scrollIndicatorInsets = contentInsets
    }
}
