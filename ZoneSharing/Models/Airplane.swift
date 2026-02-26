//
//  Airplane.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

/// Pre-resolved airplane data for synchronous view access.
struct FlightManifest: Identifiable {
    let id: String
    let gate: String
    let passengers: [Contact]
    let airplane: Airplane<Contact>
}

public actor Airplane<T: Identifiable>: Identifiable {
    public let id: String
    var flight: CKFlight?
    private(set) var passengers: [T] = []

    var gate: String? {
        flight?.flightID
    }

    init(flight: CKFlight? = nil) {
        self.id = flight?.flightID ?? UUID().uuidString
        self.flight = flight
    }

    func board(_ passenger: T) {
        passengers.append(passenger)
    }

    func deplane(_ object: T) {
        passengers.removeAll(where: { $0.id == object.id })
    }
}
