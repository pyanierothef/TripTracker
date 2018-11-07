//
//  TripsPresenter.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/7/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

protocol TripsPresenter {
    var trips : [Trip] {get}
    
    func updateTrips()
}
