//
//  CKFlight.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKFlight = CKRecordZone

public extension CKFlight {
    var flightID: String {
        self.zoneID.zoneName
    }
}

actor Airplane<T: Identifiable> {
    let zone: CKFlight
    private(set) var passengers: [T] = []

    init(zone: CKFlight, passengers: [T] = []) {
        self.zone = zone
        self.passengers = passengers
    }
    
    var gate: String {
        zone.flightID
    }

    func board(_ passenger: T) {
        passengers.append(passenger)
    }

    func deplane(_ object: T) {
        passengers.removeAll(where: { $0.id == object.id } )
    }
}
