//
//  Trip.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

struct Trip {
    let startDate : Date
    let endDate : Date
    let waypoints : [Waypoint]
    
    init(startDate: Date, endDate: Date, waypoints: [Waypoint]) {
        self.startDate = startDate
        self.endDate = endDate
        self.waypoints = waypoints
    }
}
