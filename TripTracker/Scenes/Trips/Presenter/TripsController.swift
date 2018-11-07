//
//  TripsController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/7/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

class TripsController : TripsPresenter {
    var trips: [Trip] = []
    
    private let tripsView : TripsView
    
    init(tripsView: TripsView) {
        self.tripsView = tripsView
    }
    
    func updateTrips() {
        do {
            let database = try Container()
            let result = database.values(Trip.self, matching: Trip.Query.all)
            trips = result.allValues()
            
            tripsView.didUpdateTrips()
        }
        catch {
            print("Failed to get Trips \(error)")
        }
    }
}
