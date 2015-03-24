//
//  MakeWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit

class MakeWorkoutViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var now = NSDate()
    var startDateTime:NSDate?
    var endDateTime:NSDate?
    var currentTF:UITextField?
    @IBOutlet weak var inputForm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
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
        switch section {
        case 0:
            textLabel.text = "When?"
        case 1:
            textLabel.text = "Where?"
        case 2:
            textLabel.text =  "Which Workout?"
        default:
            textLabel.text =  "New Input"
        }
        return textLabel
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inputFieldCell") as MakeWorkoutInputFieldCell
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            switch row {
            case 0:
                cell.fieldname.text = "DATE"
                let pickerView = UIDatePicker()
                let toolbar = UIToolbar(frame: CGRectMake(0, -40, 320, 40))
                pickerView.datePickerMode = UIDatePickerMode.Date
                pickerView.minimumDate = now
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingDate")
                let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
                let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton, flex, doneButton], animated: true)
                cell.inputTF.inputView = pickerView
                cell.inputTF.inputAccessoryView = toolbar
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(now, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            case 1:
                cell.fieldname.text = "START TIME"
                let pickerView = UIDatePicker()
                let toolbar = UIToolbar(frame: CGRectMake(0, -40, 320, 40))
                pickerView.datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                //pickerView.minimumDate = now
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
                let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton, flex, doneButton], animated: true)
                cell.inputTF.inputView = pickerView
                cell.inputTF.inputAccessoryView = toolbar
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(now, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            case 2:
                cell.fieldname.text = "END TIME"
                let pickerView = UIDatePicker()
                let hourFromNow = now.dateByAddingTimeInterval(3600)
                let toolbar = UIToolbar(frame: CGRectMake(0, -40, 320, 40))
                pickerView.datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                //pickerView.minimumDate = now
                pickerView.date = hourFromNow
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
                let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
                toolbar.setItems([cancelButton, flex, doneButton], animated: true)
                cell.inputTF.inputView = pickerView
                cell.inputTF.inputAccessoryView = toolbar
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(hourFromNow, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            default:
                cell.fieldname.text = "new field"
            }
        case 1:
            cell.fieldname.text = "GYM"
        case 2:
            cell.fieldname.text = "TAG"
        default:
            cell.fieldname.text = "new field"
        }
        return cell
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let indexPath = inputForm.indexPathForCell(textField.superview?.superview as MakeWorkoutInputFieldCell)
        self.currentTF = textField
    }
    
    func donePickingDate() {
        println("donePickingDate")
        let datePicker = self.currentTF!.inputView as UIDatePicker
        self.currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        startDateTime = datePicker.date
        endDateTime = datePicker.date
        self.currentTF!.resignFirstResponder()
    }
    func cancelPicking() {
        self.currentTF!.resignFirstResponder()
    }
    
    func donePickingTime() {
        let datePicker = self.currentTF!.inputView as UIDatePicker
        self.currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        self.currentTF!.resignFirstResponder()
    }
    func cancelPickingDate() {
        self.currentTF!.resignFirstResponder()
    }

    
}
