//
//  Tracker.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol TrackerDelegate : class {
    func trackerDidBuildTrip(_ trip: Trip)
    func trackerDidTrackLocation(_ location: CLLocation)
}

class Tracker {
    
    static let shared = Tracker(locationManager: LocationManager.defaultManager)
    
    weak var delegate : TrackerDelegate?
    
    var isTracking : Bool = false
    
    var trackedLocations : [CLLocationCoordinate2D] {
        guard let tripBuilder = self.tripBuilder else {
            return []
        }
        
        return tripBuilder.waypoints.map{CLLocationCoordinate2DMake($0.latitude, $0.longitude)}
    }
    
    private let locationManager : LocationManager
    
    private var tripBuilder : TripBuilder?
    
    private let operationQueue = OperationQueue()
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager.addObserver(self)
    }
    
    func prepareForResume() -> Bool {
        tripBuilder = loadTripBuilder()
        if tripBuilder != nil {
            return true
        }
        
        return false
    }
    
    func startTrip() {
        
        if tripBuilder == nil {
            tripBuilder = TripBuilder()
            tripBuilder?.start()
            storeTripBuilder()
        }
        
        isTracking = true
        
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
        locationManager.stopSignificantLocationChanges()
        
        if let delegate = delegate,
           let trip = tripBuilder?.build() {
            delegate.trackerDidBuildTrip(trip)
        }
        
        deleteTripBuilder()
    }
    
    private func storeTripBuilder() {
        guard let tripBuilder = self.tripBuilder else {
            return
        }
        
        do {
            let database = try Container()
            try database.write{ transaction in
                transaction.add(tripBuilder, update: true)
            }
        } catch {
            print("Unable to store pending Trip Builder")
        }
    }
    
    private func deleteTripBuilder() {
        guard let tripBuilder = self.tripBuilder else {
            return
        }
        
        do {
            let database = try Container()
            try database.write { transaction in
                transaction.remove(tripBuilder, primaryKey: tripBuilder.id)
            }
        } catch {
            print("Unable to delete pending Trip Builder")
        }
        
        self.tripBuilder = nil
    }
    
    private func loadTripBuilder() -> TripBuilder? {
        do {
            let database = try Container()
            let results = database.values(TripBuilder.self, matching: TripBuilder.Query.all)
            if results.count > 0 {
                return results.value(at: 0)
            }
        } catch {
            print("Unable to load pending Trip Builder")
        }
        
        return nil
    }
    
}

extension Tracker : LocationObserver {
    func didUpdateLocation(_ location: CLLocation) {
        if let tripBuilder = tripBuilder {
            tripBuilder.addLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, date: location.timestamp)
            storeTripBuilder()
            if let delegate = delegate {
                delegate.trackerDidTrackLocation(location)
            }
        }
    }
}
