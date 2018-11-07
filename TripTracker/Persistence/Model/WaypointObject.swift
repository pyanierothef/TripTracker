//
//  WaypointObject.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import RealmSwift

class WaypointObject : Object {
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
    @objc dynamic var timeOffset : TimeInterval = 0.0
}

extension Waypoint: Persistable {
    
    init(managedObject: WaypointObject) {
        self.latitude = managedObject.latitude
        self.longitude = managedObject.longitude
        self.timeOffset = managedObject.timeOffset
    }
    
    func managedObject() -> WaypointObject {
        let waypoint = WaypointObject()
        waypoint.latitude = self.latitude
        waypoint.longitude = self.longitude
        waypoint.timeOffset = self.timeOffset
        
        return waypoint
    }
}

extension Waypoint {
    public enum Query: QueryType {
        
        public var predicate: NSPredicate? {
            return nil
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return []
        }
    }
}
