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
    
    @IBOutlet weak var transferLabel: UILabel!
    
    @IBOutlet weak var arrivalLocationPickerView: UIPickerView!
    
    @IBOutlet weak var departerLocationPickerView: UIPickerView!
    
    @IBOutlet weak var nearestStationLabel: UILabel!
    
    @IBOutlet weak var fareLabel: UILabel!
    
    @IBOutlet weak var departureStationLabel: UILabel!
    
    @IBOutlet weak var departureTime: UILabel!
    
    @IBOutlet weak var arrivalStationLabel: UILabel!
    
    @IBOutlet weak var arrivalTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allStations = BartClient.sharedInstance.getStations()
        self.initLocationManager()
        self.departerLocationPickerView.delegate = self
        self.departerLocationPickerView.dataSource = self
        self.departerLocationPickerView.selectRow(closestIndex, inComponent: 0, animated: true)
        var starterStationIndex = self.departerLocationPickerView.selectedRowInComponent(0)
        var endStationIndex = self.departerLocationPickerView.selectedRowInComponent(1)
        starterStation = self.allStations[starterStationIndex]
        endStation = self.allStations[endStationIndex]
        var scheduleInfo = BartClient.sharedInstance.getScheduleInfo(starterStation?.abbreviation, dest: endStation?.abbreviation)

        fareLabel.text = "$\(fare)"
        departureStationLabel.text = starterStation?.name
        arrivalStationLabel.text = endStation?.name
        transferLabel.text = transfer
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allStations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.allStations[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.starterStation = self.allStations[self.departerLocationPickerView.selectedRowInComponent(0)]
        self.endStation = self.allStations[self.departerLocationPickerView.selectedRowInComponent(1)]
        var scheduleInfo = BartClient.sharedInstance.getScheduleInfo(starterStation?.abbreviation, dest: endStation?.abbreviation)
        
        if scheduleInfo.count > 1 {
            transfer = "Transfer at:"
            for i in 0..<scheduleInfo.count-1 {
                transfer += scheduleInfo[i].origin!
            }
        } else {
            transfer = ""
        }
        
        fareLabel.text = "$\(fare)"
        departureStationLabel.text = starterStation?.name
        arrivalStationLabel.text = endStation?.name
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
        self.nearestStationLabel.text = stationName
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


}

