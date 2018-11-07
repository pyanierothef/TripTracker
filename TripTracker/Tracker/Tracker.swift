//
//  Tracker.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import CoreLocation

protocol TrackerDelegate : class {
    func trackerDidBuildTrip(_ trip: Trip)
    func trackerDidTrackLocation(_ location: CLLocation)
}

class Tracker {
    
    static let shared = Tracker(locationManager: LocationManager.defaultManager)
    
    weak var delegate : TrackerDelegate?
    
    var isTracking : Bool = false
    
    private let locationManager : LocationManager
    
    private var tripBuilder : TripBuilder?
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager.addObserver(self)
    }
    
    func startTrip() {
        
        isTracking = true
        tripBuilder = TripBuilder()
        tripBuilder?.start()
        
        self.locationManager.setUp { locManager in
           // locManager.activityType = .automotiveNavigation
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.distanceFilter = kCLDistanceFilterNone
            locManager.pausesLocationUpdatesAutomatically = false
        }
        locationManager.startUpdatingLocation()
        locationManager.startSignificantLocationChanges()
    }
    
    func endTrip() {
        isTracking = false
        tripBuilder?.endTrip()
        locationManager.stopUpdatingLocation()
        locationManager.startSignificantLocationChanges()
        
        if let delegate = delegate,
           let trip = tripBuilder?.build() {
            delegate.trackerDidBuildTrip(trip)
        }
        
        tripBuilder = nil
    }
    
}

extension Tracker : LocationObserver {
    func didUpdateLocation(_ location: CLLocation) {
        if let tripBuilder = tripBuilder {
            tripBuilder.addLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: location.timestamp)
            if let delegate = delegate {
                delegate.trackerDidTrackLocation(location)
            }
        }
    }
}
