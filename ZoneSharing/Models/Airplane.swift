//
//  Airplane.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

actor Airplane<T: Identifiable> {
    var flight: CKFlight?
    private(set) var passengers: [T] = []
    
    var gate: String? {
        flight?.flightID
    }

    func board(_ passenger: T) {
        passengers.append(passenger)
    }

    func deplane(_ object: T) {
        passengers.removeAll(where: { $0.id == object.id } )
    }
}
