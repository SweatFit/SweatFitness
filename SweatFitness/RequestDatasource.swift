//
//  RequestDatasource.swift
//  SweatFitness
//
//  Created by James Whang on 3/30/15.
//  Copyright (c) 2015 Sweat. All rights reserved.
//

import Foundation
import Parse

/*  --------BaseRequest--------
    Base class for all requests
    This class is inherited by all other Request classes
    Contains abstract methods
*/

class BaseRequest {
    var sourceID:String?
    var destID:String?
    var delegate:BaseRequestDelegate?
    
    init(sourceID: String, destID: String) {
        self.sourceID = sourceID
        self.destID = destID
    }
}

protocol BaseRequestDelegate {
    func saveRequestSuccess(success: Bool)
}

/* --------WorkoutRequest--------
    Class for Workout Requests
    Used for sending/receiving workout requests
*/
class WorkoutRequest : BaseRequest {
    var targetWorkoutID:String?
    var requestObj = PFObject(className: "WorkoutRequestObject")
    
    init(sourceID: String, destID: String, targetWorkoutID: String) {
        super.init(sourceID: sourceID, destID: destID)
        self.targetWorkoutID = targetWorkoutID
    }
    
    func makeRequest() -> Void {
        var saved:Bool?
        self.requestObj["senderID"] = self.sourceID
        self.requestObj["receiverID"] = self.destID
        self.requestObj["taxrgetWorkoutID"] = self.targetWorkoutID
        requestObj.saveInBackgroundWithBlock {
            (success: Bool, Error: NSError!) -> Void in
            if(success) {
                self.delegate!.saveRequestSuccess(success)
            } else {
                println("Failed to create workout")
            }
        }
    }
    
    func cancelRequest() -> Void {
        // jwhang: TODO
        // May need to change this later to one with callbacks (deleteInBackgroundWithBlock)
        self.requestObj.delete()
    }
}