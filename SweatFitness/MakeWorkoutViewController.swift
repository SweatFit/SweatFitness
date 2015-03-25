//
//  MakeWorkoutViewController.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 2/15/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import UIKit

class MakeWorkoutViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var formModel:MakeWorkoutFormModel?
    var gyms = ["SPAC","Blomquist","Patten"]
    var currentTF:UITextField?
    @IBOutlet weak var inputForm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formModel = MakeWorkoutFormModel()
        //println(NSDateFormatter.localizedStringFromDate(startDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        //println(NSDateFormatter.localizedStringFromDate(endDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func next() {
        //validate user-input data
        if formModel!.validateFormModel() {
            //if it's valid
            //make async request (or sync?)
            //perform segue
        } else {
            //alert user here? maybe alert should be dynamically shown to the user as they input
            //so call validateFormModel() every time user inputs a piece of data?
        }
        
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
        textLabel.text = self.formModel!.fieldSections![section]
        return textLabel
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formModel!.fieldNames![section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inputFieldCell") as MakeWorkoutInputFieldCell
        let section = indexPath.section
        let row = indexPath.row
        cell.fieldname.text = self.formModel!.fieldNames![section][row]
        var pickerView:UIView?
        var toolbar:UIToolbar?
        switch section {
        case 0:
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
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.now!, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            case 1:
                (pickerView as UIDatePicker).datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.startDateTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            case 2:
                (pickerView as UIDatePicker).datePickerMode = UIDatePickerMode.Time
                //pickerView.minuteInterval = 15
                (pickerView as UIDatePicker).date = formModel!.endDateTime!
                doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingTime")
                cell.inputTF.text = NSDateFormatter.localizedStringFromDate(formModel!.endDateTime!, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            default:
                println("implement new field case")
            }
            toolbar!.items!.append(doneButton!)
            cell.inputTF.inputView = pickerView
            cell.inputTF.inputAccessoryView = toolbar
        case 1:
            pickerView = UIPickerView()
            (pickerView as UIPickerView).delegate = self
            (pickerView as UIPickerView).dataSource = self
            toolbar = UIToolbar(frame: CGRectMake(0, -40, tableView.superview!.bounds.width, 40))
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePickingGym")
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPicking")
            let flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            toolbar!.setItems([cancelButton, flex, doneButton], animated: true)
            cell.inputTF.inputView = pickerView
            cell.inputTF.inputAccessoryView = toolbar
            cell.inputTF.placeholder = "Select Gym..."
        case 2:
            cell.inputTF.placeholder = "#legs"
        default:
            println("implement new section case")
        }
        
        return cell
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTF = textField
    }
    
    ////////////////////////////////////////////////////////////////////////
    // actions for toolbar items
    ////////////////////////////////////////////////////////////////////////
    func donePickingDate() {
        println("donePickingDate")
        let datePicker = self.currentTF!.inputView as UIDatePicker
        formModel!.donePickingDateFromPicker(datePicker)
        self.currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        self.currentTF!.resignFirstResponder()
    }
    func cancelPicking() {
        self.currentTF!.resignFirstResponder()
    }
    
    func donePickingTime() {
        let indexPath = inputForm.indexPathForCell(self.currentTF!.superview!.superview as MakeWorkoutInputFieldCell)
        let datePicker = self.currentTF!.inputView as UIDatePicker
        formModel!.donePickingTimeFromPicker(datePicker, withIndexPath: indexPath)
        self.currentTF!.text = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
                self.currentTF!.resignFirstResponder()
    }
    
    func donePickingGym() {
        formModel!.selectedGym = gyms[(currentTF!.inputView as UIPickerView).selectedRowInComponent(0)]
        currentTF!.text = formModel!.selectedGym
        currentTF!.resignFirstResponder()
    }

    
}
