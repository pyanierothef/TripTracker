//
//  TripPresenter.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation

protocol TripPresenter {
    
    var inTrip : Bool {get}
    
    func startTrip()
    func endTrip()
}
