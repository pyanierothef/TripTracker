//
//  TripDetailController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/7/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

class TripDetailController : TripDetailPresenter {
    
    var trip : Trip
    
    private let tripDetailView : TripDetailView
    
    init(view: TripDetailView, trip: Trip) {
        self.tripDetailView = view
        self.trip = trip
    }
}
