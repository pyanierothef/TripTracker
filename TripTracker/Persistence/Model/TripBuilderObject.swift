//
//  TripBuilderObject.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/8/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import RealmSwift

class TripBuilderObject : Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var startDate : Date = Date()
    let waypoints = List<WaypointObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension TripBuilder: Persistable {

    convenience init(managedObject: TripBuilderObject) {
        self.init()
        self.id = managedObject.id
        self.startDate = managedObject.startDate
        self.waypoints = managedObject.waypoints.map{Waypoint(managedObject:$0)}
    }
    
    func managedObject() -> TripBuilderObject {
        let trip = TripBuilderObject()
        trip.id = self.id
        trip.startDate = self.startDate ?? Date()
        trip.waypoints.append(objectsIn: self.waypoints.map{$0.managedObject()})
        
        return trip
    }
    
    
}

extension TripBuilder {
    public enum Query: QueryType {
        
        case atDate(Date)
        case all
        
        public var predicate: NSPredicate? {
            switch self {
            case .atDate(let value):
                return NSPredicate(format: "startDate == %@", argumentArray: [value])
            case .all:
                return nil
            }
        }
        
        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "startDate", ascending: false)]
        }
    }
}
