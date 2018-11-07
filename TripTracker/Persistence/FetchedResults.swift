//
//  FetchedResults.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import Foundation
import RealmSwift

class FetchedResults<T: Persistable> {
    internal let results: Results<T.ManagedObject>
    
    var count: Int {
        return results.count
    }
    
    internal init(results: Results<T.ManagedObject>) {
        self.results = results
    }
    
    func value(at index: Int) -> T {
        return T(managedObject: results[index])
    }
    
    func allValues() -> [T] {
        return results.map{ tripObject in
            T(managedObject: tripObject)
        }
    }
}
