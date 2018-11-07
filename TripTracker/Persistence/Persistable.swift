//
//  Persistable.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    associatedtype Query: QueryType
    
    init(managedObject: ManagedObject)
    
    func managedObject() -> ManagedObject
}
