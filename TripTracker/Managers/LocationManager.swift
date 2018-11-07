//
//  LocationManager.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 10/26/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationObserver : class {
    func didUpdateLocation(_ location: CLLocation)
}


class LocationManager : NSObject {
    
    static var defaultManager = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    private var observers : [LocationObserver] = []
    let semaphore = DispatchSemaphore(value: 1)
    
    var location : CLLocation? {
        return locationManager.location
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        defaultSetUp()
    }
    
   func addObserver(_ observer: LocationObserver) {
        semaphore.wait()
        observers.append(observer)
        semaphore.signal()
    }
    
    func removeObserver(_ observer: LocationObserver) {
        semaphore.wait()
        if let index = observers.firstIndex(where: { (obs : LocationObserver) -> Bool in
            return obs === observer
        }) {
            observers.remove(at: index)
        }
        semaphore.signal()
    }
    
    func notify(location: CLLocation) {
        semaphore.wait()
        observers.forEach { observer in
            observer.didUpdateLocation(location)
        }
        semaphore.signal()
    }
    
    private func defaultSetUp() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func setUp(_ configBlock: (CLLocationManager) -> ()) {
        configBlock(locationManager)
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startSignificantLocationChanges() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not Determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("Always Authorized")
        case .authorizedWhenInUse:
            print("When in use Authorized")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first,
            Date().timeIntervalSince(location.timestamp) < 120 {
            notify(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
