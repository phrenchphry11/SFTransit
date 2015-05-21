//
//  RouteTableViewController.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/20/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class RouteTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var stations: [Station]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None

    }
    
    func assignStations(stationsPassed: [Station]){
        self.stations = stationsPassed
        if let tbView = self.tableView{
            tbView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension RouteTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let stations = stations {
            return stations.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as! StationCell
        var station = stations![indexPath.row]
        cell.setStation(station)
        return cell
    }
}

extension RouteTableViewController: UITableViewDelegate {
    
}
