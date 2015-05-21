//
//  ScheduleInformation.swift
//  SFTransit
//
//  Created by Holly French on 5/18/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit


class ScheduleInformation: NSObject {
    
    
    //Legs of a trip
    
    //End destination of the train, needed in ETD to know what train take into account from the whole list
    var legTrainHeadStation:String?
    //End destination of the leg, if there is a transfer it is a different station than legTrainHeadStation
    var legDestination:String?
    //If empty there are no transfers, otherwise is not the last leg.
    var legTransfercode:String?
    //Start time
    var legDestTimeMin:String?
    //Start day
    var legDestTimeDate:String?
    //End day
    var legMaxTrip:Int?
    
    var origTimeMin: String?
    
    var fare: String?
    
    var origin: String?
    
    var route: String? // the Line/Route which has a list of stations and a color associated
    
    init(legTrainHeadStation: String?, legDestination: String?, legTransfercode: String?){
        
        self.legTrainHeadStation = legTrainHeadStation
        self.legDestination = legDestination
        self.legTransfercode = legTransfercode
    }
    
    init(legTrainHeadStation: String?, legDestination: String?, legTransfercode: String?, legDestTimeMin: String?, legDestTimeDate: String?, origTimeMin: String?, fare: String?, origin: String?, route: String?){
        
        //Default values trip can't be shorter than 2 minutes
        self.legMaxTrip = 120
        
        self.legTrainHeadStation = legTrainHeadStation
        self.legDestination = legDestination
        self.legTransfercode = legTransfercode
        self.legDestTimeMin = legDestTimeMin
        self.legDestTimeDate = legDestTimeDate
        self.origTimeMin = origTimeMin
        self.fare = fare
        self.origin = origin
        self.route = route
        
        //Set date and time formats
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm a"
        let completeFormatter = NSDateFormatter()
        completeFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        
        let nowDate:NSDate = NSDate()
        let destDate:NSDate = completeFormatter.dateFromString(legDestTimeDate! + " " + legDestTimeMin!)!
        
        var maxTripTime = destDate.timeIntervalSinceDate(nowDate)
        self.legMaxTrip = Int(maxTripTime)
        
    }
    
}
