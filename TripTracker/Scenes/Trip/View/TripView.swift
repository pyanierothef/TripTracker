//
//  TripView.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import CoreLocation

protocol TripView {
    
    func didStartTrip()
    func didEndTrip()
    func updateTraveledPath(_ path: [CLLocationCoordinate2D])
}
