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
    
  
    @IBOutlet weak var transferLabel: UILabel!

    //@IBOutlet weak var nearestStationLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
   // @IBOutlet weak var departureStationLabel: UILabel!
    
    @IBOutlet weak var departureTime: UILabel!
    
    //@IBOutlet weak var arrivalStationLabel: UILabel!
    
    @IBOutlet weak var arrivalTime: UILabel!
    
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var toText: UITextField!


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
            fareLabel.font = UIFont.getLato(.Regular, fontSize: 2.0)
            fareLabel.text = "$\(scheduleInfo.first!.fare!)"
            
        } else {
            fareLabel.text = "$0.00"
        }

        if let starterStation = starterStation, endStation = endStation {
          //  departureStationLabel.text = starterStation.name
          //  arrivalStationLabel.text = endStation.name
        }

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
        var closestLocationDistance: CLLocationDistance = -1
        var index = 0
        var closestIndex = 0
        for location in self.allStations {
            if closestLocation != nil {
                var closestLocationObj = closestLocation!.location
                var currentDistance = curLocation.distanceFromLocation(closestLocationObj)
                if currentDistance < closestLocationDistance {
                    closestLocation = location
                    closestLocationDistance = currentDistance
                    closestIndex = index
                }
            } else {
                closestLocation = location
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
            MMPickerView.dismissWithCompletion({ (someString) -> Void in
                self.stationsChanged(originIndex: self.getStationIndexByName(self.fromText.text),
                    destinationIndex: self.getStationIndexByName(self.toText.text))
            })
        }
    }
    @IBAction func onToTouchDown(sender: AnyObject) {
        MMPickerView.showPickerViewInView(view, withStrings: self.getAllStationNames(), withOptions: nil) { (selectedString) -> Void in
            self.toText.text = selectedString
            MMPickerView.dismissWithCompletion({ (someString) -> Void in
                self.stationsChanged(originIndex: self.getStationIndexByName(self.fromText.text),
                    destinationIndex: self.getStationIndexByName(self.toText.text))
            })
        }
    }
    @IBAction func onLocationImgTap(sender: AnyObject) {
        self.initLocationManager()
        println("button tapped")
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
}

