//
//  Waypoint.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

struct Waypoint {
    let latitude : Double
    let longitude : Double
    let timeOffset : TimeInterval
    
    init(latitude: Double, longitude: Double, timeOffset: TimeInterval) {
        self.latitude = latitude
        self.longitude = longitude
        self.timeOffset = timeOffset
    }
}
