//
//  TripObject.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import RealmSwift

class TripObject : Object {
    @objc dynamic var startDate : Date = Date()
    @objc dynamic var endDate : Date = Date()
    let waypoints = List<WaypointObject>()
}

extension Trip: Persistable {
    
    init(managedObject: TripObject) {
        self.startDate = managedObject.startDate
        self.endDate = managedObject.endDate
        self.waypoints = managedObject.waypoints.map{Waypoint(managedObject:$0)}
    }
    
    func managedObject() -> TripObject {
        let trip = TripObject()
        trip.startDate = self.startDate
        trip.endDate = self.endDate
        trip.waypoints.append(objectsIn: self.waypoints.map{$0.managedObject()})
        
        return trip
    }
    
   
}

extension Trip {
    public enum Query: QueryType {
        
        case atDate(Date)
        case all
        
        public var predicate: NSPredicate? {
            switch self {
            case .atDate(let value):
                return NSPredicate(format: "startDate < %@ // endDate > %@,", argumentArray: [value, value])
            case .all:
                return nil
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "startDate", ascending: false)]
        }
    }
}
