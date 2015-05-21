//
//  NSDate+Utils.swift
//  SFTransit
//
//  Created by Amie Kweon on 5/20/15.
//  Copyright (c) 2015 Holly French. All rights reserved.
//

import UIKit

extension NSDate {
    static func shortTimeAgoSince(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)

        if (components.year >= 1) {
            return "\(components.year)y"
        } else if (components.month >= 1) {
            return "\(components.month)m"
        } else if (components.weekOfYear >= 1) {
            return "\(components.weekOfYear)w"
        } else if (components.day >= 1) {
            return "\(components.day)d"
        } else if (components.hour >= 1) {
            return "\(components.hour)h"
        } else if (components.minute >= 1) {
            return "\(components.minute)m"
        } else if (components.second >= 3) {
            return "\(components.second)s"
        } else {
            return "now"
        }
    }
}
