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

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var allStations: [NSDictionary] = []
    var lastLocation = CLLocation()
    var locationAuthorizationStatus: CLAuthorizationStatus!
    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    var nearestStation: NSDictionary?
    var closestIndex: Int = 0
    
    @IBOutlet weak var arrivalLocationPickerView: UIPickerView!
    
    @IBOutlet weak var departerLocationPickerView: UIPickerView!
    
    @IBOutlet weak var nearestStationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateStations()
        self.initLocationManager()
        self.departerLocationPickerView.delegate = self
        self.departerLocationPickerView.dataSource = self
        self.departerLocationPickerView.selectRow(closestIndex, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateStations() {
//        var fourthStreet = ["name": "Fourth and King", "location": CLLocation(latitude: 37.776905, longitude: -122.395012)]
//        allStations.append(fourthStreet)
//        var twentySecondStreet = ["name": "22nd Street Caltrain", "location": CLLocation(latitude: 37.757674, longitude: -122.392636)]
//        allStations.append(twentySecondStreet)
//        var paloAlto = ["name": "Palo Alto", "location": CLLocation(latitude: 37.44307, longitude: -122.392636)]
//        allStations.append(paloAlto)
        
        var stopName: String!
        var stopLat: Double?
        var stopLong: Double?
        var stationInfo: Dictionary<String, AnyObject> = [:]
        
        if let url = NSURL(fileURLWithPath: "/Users/hfrench/codepath/SFTransit/SFTransit/Data/stops.txt") {
            var error: NSErrorPointer = nil
            if let csv = CSV(contentsOfURL: url, error: error) {
                // Rows
                let rows = csv.rows
                for row in rows {
                    if row["platform_code"] == "NB" {
                        continue
                    }
                    stopName = row["stop_name"]!
                    stopLat = NSString(string: row["stop_lat"]!).doubleValue
                    stopLong = NSString(string: row["stop_lon"]!).doubleValue
                    stationInfo["name"] = stopName.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

                    stationInfo["location"] = CLLocation(latitude: stopLat!, longitude: stopLong!)
                    allStations.append(stationInfo)
                }
            }
            
            println(allStations)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allStations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.allStations[row]["name"] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected row")
        println(self.allStations[self.departerLocationPickerView.selectedRowInComponent(0)]["name"])
        println(self.allStations[self.departerLocationPickerView.selectedRowInComponent(1)]["name"])
        println("---------------")
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
        (self.nearestStation, closestIndex) = getNearestCaltrainStation(manager.location)
        var stationName = self.nearestStation!["name"] as? String
        self.nearestStationLabel.text = stationName
    }
    
    func getNearestCaltrainStation(curLocation: CLLocation) -> (NSDictionary?, Int) {
        var closestLocation: NSDictionary?
        var closestLocationDistance: CLLocationDistance = -1
        var index = 0
        var closestIndex = 0
        for location in self.allStations {
            if closestLocation != nil {
                var closestLocationObj = closestLocation!["location"] as! CLLocation
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


}

