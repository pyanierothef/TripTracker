//
//  TripController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import CoreLocation

class TripController : TripPresenter {
    
    private let tracker = Tracker.shared
    private let tripView : TripView
    private var currentTrack : [CLLocationCoordinate2D] = []
    
    init(tripView: TripView) {
        self.tripView = tripView
        tracker.delegate = self
    }
    
    var inTrip: Bool {
        return tracker.isTracking
    }
    
    func startTrip() {
        tracker.startTrip()
        tripView.didStartTrip()
    }
    
    func endTrip() {
        tracker.endTrip()
        tripView.didEndTrip()
        currentTrack.removeAll()
    }
}

extension TripController : TrackerDelegate {
    func trackerDidBuildTrip(_ trip: Trip) {
        do {
            let database = try Container()
            try database.write { transaction in
                transaction.add(trip, update: false)
            }
        } catch {
            print("Failed to persist trip: \(error)")
        }
    }
    
    func trackerDidTrackLocation(_ location: CLLocation) {
        currentTrack.append(location.coordinate)
        tripView.updateTraveledPath(currentTrack)
    }
}
