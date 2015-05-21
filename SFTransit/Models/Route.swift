//
//  Route.swift
//  SFTransit
//
//  Created by Holly French on 5/20/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

class Route: NSObject {
    var routeColor: String?
    var routeName: String?
    var routeId: String?
    var routeNum: String?
    var routeAbbr: String?
    
    init(routeColor: String?, routeName: String?, routeId: String?, routeNum: String?, routeAbbr: String?){
        self.routeColor = routeColor
        self.routeName = routeName
        self.routeId = routeId
        self.routeNum = routeNum
        self.routeAbbr = routeAbbr
    }
    
    func getAllRouteStations() {
        
    }
}
