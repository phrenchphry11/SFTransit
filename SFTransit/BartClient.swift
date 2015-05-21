//
//  BartClient.swift
//  SFTransit
//
//  Created by Holly French on 5/18/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//  Used some help from: https://github.com/jschapiro003/BARTNap and http://stackoverflow.com/questions/27511576/accessing-values-of-elements-when-using-nsxmlparser-in-swift :)

import UIKit

let BART_API_KEY = "Q9VR-UBYB-I97Q-DT35"
let BART_API_URL = "http://api.bart.gov/api/"

class BartClient: NSObject, NSXMLParserDelegate {

    var parser:NSXMLParser?
    var parseSuccess:Bool = true
    
    var stations = Array<Station>()
    var stationName: Bool?
    var stationAbbreviation: Bool?
    var stationLatitude: Bool?
    var stationLongitude: Bool?
    var currentStationName: String?
    var currentAbbreviationName: String?
    var currentLatitudeName: String?
    var currentLongitudeName: String?
    
    var currentElement: String = ""
    var passData: Bool = false
    var passObject: Bool = false
    var parsingStations: Bool = false
    var parsingSchedules: Bool = false
    var parsingRoutes: Bool = false
    var parsingETD: Bool = false
    
    var origin: String?
    var fare: String?
    var origTimeMin: String?
    var dest: String?
    var legFound: Bool? = false
    var legDestination: String?
    var legTrainHeadStation: String?
    var legTransfercode: String?
    var legDestTimeMin: String?
    var legDestTimeDate: String?
    var bartLine: String?
    
    var routes = Array<Route>()
    var routeColor: Bool?
    var routeName: Bool?
    var routeId: Bool?
    var routeNum: Bool?
    var routeAbbr: Bool?
    var routeFound: Bool? = false
    var routeStationsFound: Bool? = false
    var currentRouteColor: String?
    var currentRouteName: String?
    var currentRouteId: String?
    var currentRouteNum: String?
    var currentRouteAbbr: String?
    var currentRouteStations = Array<String>()
    
    var tripData: ScheduleInformation?
    var legs = Array<ScheduleInformation>()
    
    class var sharedInstance: BartClient {
        struct Static{
            static let instance =  BartClient()
        }
        return Static.instance
    }
    
    func getStations() -> Array<Station> {
        parser = NSXMLParser(contentsOfURL: NSURL(string: BART_API_URL + "stn.aspx?cmd=stns&key=" + BART_API_KEY))!

        if let xmlParser = parser {
            xmlParser.delegate = self
            xmlParser.parse()
        }
        return stations
        
    }
    
    func getRoutes() -> Array<Route> {
        var url: String = BART_API_URL + "route.aspx?cmd=routes&key=" + BART_API_KEY
        
        parser = NSXMLParser(contentsOfURL: NSURL(string: url))!
        
        if let xmlParser = parser {
            xmlParser.delegate = self
            xmlParser.parse()
        }
        return routes
    }
    
    func getScheduleInfo(origin: String!, dest: String!) -> Array<ScheduleInformation> {
        
        //Empty legs
        legs = Array<ScheduleInformation>()
        
        self.origin = origin
        self.dest = dest
        
        var url: String = BART_API_URL + "sched.aspx?cmd=depart&orig=" + origin + "&dest=" + dest + "&date=now&key=" + BART_API_KEY + "&b=0&a=1"
        parser = NSXMLParser(contentsOfURL: NSURL(string: url))!
        
        if let xmlParser = parser {
            xmlParser.delegate = self
            xmlParser.parse()
        }
        
        
        for leg in legs {
            
            let rangeOfIdStr = Range(start: advance(leg.routeId!.startIndex, 6),
                end: leg.routeId!.endIndex)
            let idStr = leg.routeId?.substringWithRange(rangeOfIdStr)
            var routes = BartClient.sharedInstance.getRouteScheduleStops(idStr)
            for route in routes {
                if route.routeId == leg.routeId {
                    leg.route = route
                }
            }
        }
        
        return legs
    }
    
    func getRouteScheduleStops(routeId: String!) -> Array<Route> {
        
        routes = Array<Route>()
        
        var url: String = BART_API_URL + "route.aspx?cmd=routeinfo&route=" + routeId + "&key=" + BART_API_KEY
        parser = NSXMLParser(contentsOfURL: NSURL(string: url))!
        if let xmlParser = parser {
            xmlParser.delegate = self
            xmlParser.parse()
        }
        return routes
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentElement = elementName
        
        // Stations-related attributes
        if elementName == "stations" || elementName == "station" || elementName == "name" || elementName == "abbr" || elementName == "gtfs_latitude" || elementName == "gtfs_longitude" {
            //Establish the parsing in process
            if elementName == "stations" {
                parsingStations = true
            }
            
            if elementName == "station" && parsingStations {
                passObject = true
            }
            
            passData = true
            
            self.stationName = (elementName == "name")
            
            self.stationAbbreviation = (elementName == "abbr")
            
            self.stationLatitude = (elementName == "gtfs_latitude")
            
            self.stationLongitude = (elementName == "gtfs_longitude")
        }
        
        // Schedule-related attributes
        if elementName == "schedule" || elementName=="trip" || elementName=="leg" {
            if elementName == "schedule" {
                parsingSchedules = true
            }
            
            //Start collecting legs, there is a trip
            if(elementName == "trip" && parsingSchedules){
                passObject = true
                fare = attributeDict["fare"] as! String?
                origTimeMin = attributeDict["origTimeMin"] as! String?
            }
            
            passData = true
            //get attributes of the leg, this one doesn't work with foundCharacters func
            if elementName == "leg" && parsingSchedules {
                legFound=true
                legDestination = attributeDict["destination"] as! String?
                legTrainHeadStation = attributeDict["trainHeadStation"] as! String?
                legTransfercode = attributeDict["transfercode"] as! String?
                legDestTimeMin = attributeDict["destTimeMin"] as! String?
                legDestTimeDate = attributeDict["destTimeDate"] as! String?
                origin = attributeDict["origin"] as! String
                bartLine = attributeDict["line"] as! String
            }
        }
        
        // Route-related attributes 
        if elementName == "routes" || elementName == "route" || elementName == "name" || elementName == "abbr" || elementName == "routeID" || elementName == "number" || elementName == "color" || elementName == "config" {
            
            //Establish the parsing in process
            if elementName == "routes" {
                parsingRoutes = true
            }
            
            if elementName == "route" && parsingRoutes {
                passObject = true
            }
            
            passData = true
            
            self.routeColor = (elementName == "color")
            
            self.routeName = (elementName == "name")
            
            self.routeId = (elementName == "routeID")
            
            self.routeNum = (elementName == "number")
            
            self.routeAbbr = (elementName == "abbr")
            
            self.routeStationsFound = (elementName == "config")
            
        }
  
        
    }

    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        
        //ended for parsing stations
        if(elementName == "stations" || elementName == "station" || elementName == "name" || elementName == "abbr" || elementName == "gtfs_latitude" || elementName == "gtfs_longitude") {
            if elementName=="station" && parsingStations {
                passObject = false
                //create new station and populate it
                var station: Station = Station(name: currentStationName, abbreviation: currentAbbreviationName, latitude: currentLatitudeName, longitude: currentLongitudeName)
                // add that station to the stations array
                stations.append(station)
            }
            passData = false
            //Parsing stations ended
            if(elementName=="stations"){
                parsingStations=false
            }
        }
        
        if(elementName == "schedule" || elementName == "trip"  || elementName == "leg")
        {
            if(elementName == "leg" && parsingSchedules){
                passObject = false
                //create new leg and populate it
                var leg:ScheduleInformation = ScheduleInformation(legTrainHeadStation: legTrainHeadStation, legDestination: legDestination, legTransfercode: legTransfercode, legDestTimeMin: legDestTimeMin, legDestTimeDate: legDestTimeDate, origTimeMin: origTimeMin, fare: fare, origin: origin, route: bartLine)
                // add that leg to the legs array
                legs.append(leg)
            }
            passData = false
            if(elementName == "schedule"){
                parsingSchedules = false
            }
        }
        
        if elementName == "routes" || elementName == "route" || elementName == "name" || elementName == "abbr" || elementName == "routeID" || elementName == "number" || elementName == "color" || elementName == "config" {
            
            //ended for parsing routes
 
            if elementName=="route" && parsingRoutes {
                passObject = false
                //create new station and populate it
                
                var route: Route = Route(routeColor: currentRouteColor, routeName: currentRouteName, routeId: currentRouteId, routeNum: currentRouteNum, routeAbbr: currentRouteAbbr, routeStations: currentRouteStations)
                    routes.append(route)
            }
                
            passData = false
            //Parsing stations ended
            if(elementName == "routes"){
                parsingRoutes=false
            }
                
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if passObject {
            
            if parsingStations {
                //grab each station
                if let stationFound = self.stationName {
                    if stationFound {
                        currentStationName = string
                    }
                }
                
                //grab each station abbreviation
                if let abbreviationFound = self.stationAbbreviation {
                    if abbreviationFound {
                        currentAbbreviationName = string
                    }
                }
                
                //grab each station latitude
                if let latitudeFound = self.stationLatitude {
                    if latitudeFound {
                        currentLatitudeName = string
                    }
                }
                
                //grab each station longitude
                if let longitudeFound = self.stationLongitude {
                    if longitudeFound {
                        currentLongitudeName = string
                    }
                }
            }
            
            if parsingRoutes {
                
                if let routeColorFound = self.routeColor {
                    if routeColorFound {
                        currentRouteColor = string
                        self.routeColor = false
                    }
                }
                
                if let routeNameFound = self.routeName {
                    if routeNameFound {
                        currentRouteName = string
                    }
                }
                
                if let routeIdFound = self.routeId {
                    if routeIdFound {
                        currentRouteId = string
                    }
                }
                
                if let routeNumFound = self.routeNum {
                    if routeNumFound {
                        currentRouteNum = string
                    }
                }
                
                if let routeAbbrFound = self.routeAbbr {
                    if routeAbbrFound {
                        currentRouteAbbr = string
                    }
                }
                
                if let routeStationsFound = self.routeStationsFound {
                    if routeStationsFound {
                        currentRouteStations.append(string!)
                    }
                }
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    
    
}
