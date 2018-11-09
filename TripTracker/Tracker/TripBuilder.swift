//
//  TripBuilder.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

final class TripBuilder {
    
    var id = UUID().uuidString
    var startDate : Date?
    var endDate : Date?
    var waypoints : [Waypoint] = []
    
    func start() {
        startDate = Date()
    }
    
    func addLocation(latitude: Double, longitude: Double, date: Date) {
        if let startDate = startDate {
            let waypoint = Waypoint(latitude: latitude, longitude: longitude, timeOffset: date.timeIntervalSince(startDate))
            waypoints.append(waypoint)
        }
    }
    
    func endTrip() {
        endDate = Date()
    }
    
    func build() -> Trip? {
        guard let startDate = startDate,
            let endDate = endDate  else {
            return nil
        }
        
        return Trip(startDate: startDate, endDate: endDate, waypoints: waypoints)
    }
}
