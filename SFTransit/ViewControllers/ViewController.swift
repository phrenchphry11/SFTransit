//
//  ViewController.swift
//  SFTransit
//
//  Created by Holly French on 5/17/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import SwiftCSV
import CoreLocation
import UIKit
import MMPickerView

class ViewController: UIViewController, CLLocationManagerDelegate {
    var allStations: [Station] = []
    var lastLocation = CLLocation()
    var locationAuthorizationStatus: CLAuthorizationStatus!
    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    var nearestStation: Station?
    var closestIndex: Int = 0
    var starterStation: Station?
    var endStation: Station?
    var fare: String = "0.00"
    var transfer: String = ""
    var routes: [Route] = []
    
    @IBOutlet weak var depLabel: UILabel!
  
    @IBOutlet weak var arLabel: UILabel!

    @IBOutlet weak var transferLabel: UILabel!

    //@IBOutlet weak var nearestStationLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
   // @IBOutlet weak var departureStationLabel: UILabel!
    
    @IBOutlet weak var departureTime: UILabel!
    
    //@IBOutlet weak var arrivalStationLabel: UILabel!
    
    @IBOutlet weak var arrivalTime: UILabel!
    
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var toText: UITextField!

    @IBOutlet weak var faLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allStations = BartClient.sharedInstance.getStations()
        //self.initLocationManager()

        fareLabel.text = "$\(fare)"
        //departureStationLabel.text = starterStation?.name
      //  arrivalStationLabel.text = endStation?.name
        transferLabel.text = transfer

        fromText.delegate = self
        toText.delegate = self
        self.routes = BartClient.sharedInstance.getRoutes()
        for label in [self.departureTime, self.arrivalTime]{
            label.text = ""
        }
        for label in [self.depLabel, self.arLabel]{
            label.hidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func stationsChanged(#originIndex: Int, destinationIndex: Int) {
        if originIndex == -1 || destinationIndex == -1 {
            return
        }
        self.starterStation = self.allStations[originIndex]
        self.endStation = self.allStations[destinationIndex]
        var scheduleInfo = BartClient.sharedInstance.getScheduleInfo(starterStation?.abbreviation, dest: endStation?.abbreviation)

        if scheduleInfo.count > 1 {
            transfer = "Transfer at: "
            for i in 0..<scheduleInfo.count-1 {
                transfer += self.getStationDisplayNameFromAbbreviation(scheduleInfo[i].origin!)
            }
        } else {
            transfer = ""
        }

        if let fare = scheduleInfo.first?.fare {
            fareLabel.font = UIFont.getLato(.Regular, fontSize: 18.0)
            fareLabel.text = "$\(scheduleInfo.first!.fare!)"
            
        } else {
            fareLabel.text = "$0.00"
        }

        if let starterStation = starterStation, endStation = endStation {
          //  departureStationLabel.text = starterStation.name
          //  arrivalStationLabel.text = endStation.name
        }
        self.depLabel.hidden = false
        self.arLabel.hidden = false
        
        depLabel.font = UIFont.getLato(.Regular, fontSize: 18.0)
        arLabel.font = UIFont.getLato(.Regular, fontSize: 18.0)
        faLabel.font = UIFont.getLato(.Regular, fontSize: 18.0)
        departureTime.text = scheduleInfo.first?.origTimeMin
        arrivalTime.text = scheduleInfo.last?.legDestTimeMin
        transferLabel.text = transfer
        
    }

    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    
    // Location Manager Delegate stuff
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                println(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        (self.nearestStation, closestIndex) = getNearestBartStation(manager.location)
        var stationName = self.nearestStation!.name
        self.fromText.text = stationName
    }
    
    func getNearestBartStation(curLocation: CLLocation) -> (Station?, Int) {
        var closestLocation: Station?
        var closestLocationDistance: CLLocationDistance = Double.infinity
        var index = 0
        var closestIndex = 0
        for stationLocation in self.allStations {
            if closestLocation != nil {
                var closestLocationObj = closestLocation!.location
                var currentDistance = curLocation.distanceFromLocation(stationLocation.location)
                if currentDistance < closestLocationDistance {
                    closestLocation = stationLocation
                    closestLocationDistance = currentDistance
                    closestIndex = index
                }
            } else {
                closestLocation = stationLocation
            }
            index += 1
        }
        return (closestLocation!, closestIndex)
    }
    
    func getStationDisplayNameFromAbbreviation(abbreviation: NSString!) -> String {
        for station in self.allStations {
            if station.abbreviation == abbreviation {
                return station.name!
            }
        }
        
        return "No station found"
    }

    func getAllStationNames() -> [String] {
        return self.allStations.map { (station) -> String in
            return station.name!
        }
    }

    func getStationIndexByName(name: String) -> Int {
        for (index, station) in enumerate(self.allStations) {
            if station.name == name {
                return index
            }
        }
        return -1
    }

    @IBAction func onFromTouchDown(sender: AnyObject) {
        // I couldn't get this to work with `withObjects`
        MMPickerView.showPickerViewInView(view, withStrings: self.getAllStationNames(), withOptions: nil) { (selectedString) -> Void in
            self.fromText.text = selectedString
            self.stationsChanged(originIndex: self.getStationIndexByName(self.fromText.text),
                destinationIndex: self.getStationIndexByName(self.toText.text))
        }
    }
    @IBAction func onToTouchDown(sender: AnyObject) {
        MMPickerView.showPickerViewInView(view, withStrings: self.getAllStationNames(), withOptions: nil) { (selectedString) -> Void in
            self.toText.text = selectedString
            self.stationsChanged(originIndex: self.getStationIndexByName(self.fromText.text),
                destinationIndex: self.getStationIndexByName(self.toText.text))
        }
    }
    
    @IBAction func onLocationImgTap(sender: AnyObject) {
        self.initLocationManager()
        println("button tapped")
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let routesVC = segue.destinationViewController as! RouteTableViewController
        var sinfo = BartClient.sharedInstance.getScheduleInfo(self.starterStation?.abbreviation, dest: self.endStation?.abbreviation)
        self.starterStation?.time = self.departureTime.text
        self.endStation?.time = self.arrivalTime.text
        for s in sinfo{
            var st = [self.starterStation!]
            st.extend(s.getStationsCrossed())
            //looks like it includes endStation in getStationsCrossed.
            
            routesVC.assignStations(st, route: s.route! )
           
            
        
        }
        

         
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}

