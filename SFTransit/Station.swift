//
//  Station.swift
//  SFTransit
//
//  Created by Holly French on 5/18/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import CoreLocation
import UIKit

class Station: NSObject {
    
    let endPoint: String = "http://api.bart.gov/api/stn.aspx?cmd=stns&key=" + BART_API_KEY
    var name: String?
    var abbreviation: String?
    var latitude: String?
    var longitude: String?
    
    var nameFound:Bool?
    var abbreviationFound:Bool?
    var latitudeFound:Bool?
    var longitudeFound:Bool?
    
    var location = CLLocation()
    
    init(name: String?, abbreviation: String?, latitude: String?, longitude: String?){
        
        self.name = name
        self.abbreviation = abbreviation
        self.latitude = latitude
        self.longitude = longitude
        if let latitude = self.latitude {
            if let longitude = self.longitude {
                self.location = CLLocation(latitude: NSString(string: self.latitude!).doubleValue, longitude: NSString(string: self.longitude!).doubleValue)
            }
        }
        
    }
    
    func newStation(nameFound:Bool?, abbreviationFound: Bool?, latitudeFound: Bool?, longitudeFound: Bool?, elementName: String){
        
        
    }
}
