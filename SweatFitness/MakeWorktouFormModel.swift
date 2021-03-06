//
//  makeWorkoutFormModel.swift
//  SweatFitness
//
//  Created by Taiwon Chung on 3/24/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import UIKit

class InvalidInputException {
    var isInvalid:Bool!
    var errorMessage:String?
    init() {
        isInvalid = false
    }
    init(isInvalid:Bool, errorMessage:String!) {
        self.isInvalid = isInvalid
        self.errorMessage = errorMessage
    }
}

class MakeWorkoutFormModel {
    var now:NSDate?
    var calendar:NSCalendar?
    var selectedDateComps:NSDateComponents?
    var startDateTime:NSDate?
    var endDateTime:NSDate?
    var selectedGym:String?
    var Tags:[String]?
    var fieldNames:[[String]]?
    var fieldSections: [String]?
    init () {
        self.now = NSDate()
        startDateTime = now
        self.calendar = NSCalendar.currentCalendar()
        self.endDateTime = calendar!.dateByAddingUnit(NSCalendarUnit.HourCalendarUnit, value: 1, toDate: startDateTime!, options: nil)
        self.selectedDateComps = calendar!.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: now!)
        self.fieldNames = [["DATE","START TIME","END TIME"], ["GYM"], ["TAGS"]]
        self.fieldSections = [" When?", " Where?", " Which Workout?"]
    }
    func donePickingDateFromPicker(picker: UIDatePicker!) {
        let dateCompFlags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit
        self.selectedDateComps = calendar!.components(dateCompFlags, fromDate: picker.date)
        let dateTimeCompFlags = dateCompFlags | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
        let startDateTimeComps = calendar!.components(dateTimeCompFlags, fromDate: startDateTime!)
        let endDateTimeComps = calendar!.components(dateTimeCompFlags, fromDate: endDateTime!)
        startDateTimeComps.year = self.selectedDateComps!.year
        startDateTimeComps.month = self.selectedDateComps!.month
        startDateTimeComps.day = self.selectedDateComps!.day
        endDateTimeComps.year = self.selectedDateComps!.year
        endDateTimeComps.month = self.selectedDateComps!.month
        endDateTimeComps.day = self.selectedDateComps!.day
        startDateTime = calendar!.dateFromComponents(startDateTimeComps)
        endDateTime = calendar!.dateFromComponents(endDateTimeComps)
        println(NSDateFormatter.localizedStringFromDate(startDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        println(NSDateFormatter.localizedStringFromDate(endDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
    }
    func donePickingTimeFromPicker(picker: UIDatePicker!, withIndexPath indexPath:NSIndexPath!) {
        let dateTimeCompFlags = NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
        var timeComps = calendar!.components(dateTimeCompFlags, fromDate: picker.date)
        timeComps.year = self.selectedDateComps!.year
        timeComps.month = self.selectedDateComps!.month
        timeComps.day = self.selectedDateComps!.day
        switch indexPath!.row {
        case 1:
            startDateTime = calendar!.dateFromComponents(timeComps)
            println(NSDateFormatter.localizedStringFromDate(startDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        case 2:
            endDateTime = calendar!.dateFromComponents(timeComps)
            println(NSDateFormatter.localizedStringFromDate(endDateTime!, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle))
        default:
            println("other than start/end time?")
        }
    }
    
    func validateFormModel() -> InvalidInputException{
        // TODO: implement this for validating user input before sending request
        if startDateTime!.compare(endDateTime!) == NSComparisonResult.OrderedDescending {
            return InvalidInputException(isInvalid: true, errorMessage: "Start Time cannot be later than End Time.")
        } else if NSDate().compare(startDateTime!) == NSComparisonResult.OrderedDescending {
            return InvalidInputException(isInvalid: true, errorMessage: "Start Time for your workout is earlier than now.")
        } else if self.selectedGym == nil {
            return InvalidInputException(isInvalid: true, errorMessage: "Gym is not selected.")
        } else if self.Tags == nil {
            return InvalidInputException(isInvalid: true, errorMessage: "There is no tag for the workout.")
        } else if self.Tags!.count == 0 {
            return InvalidInputException(isInvalid: true, errorMessage: "There is no tag for the workout.")
        }
        return InvalidInputException()
    }
    
    func extractTagsFromString(string:String!) {
        let arr = split(string, {$0 == " "}, allowEmptySlices: false)
        self.Tags = arr
        println(self.Tags)
    }
}

