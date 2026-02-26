//
//  Airplane.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public actor Airplane<T: Socialite>: Sendable {
    public let id: String
    var flight: CKFlight?
    var passengers = Set<T>()

    var gate: String? {
        flight.getGate(from airport: CKAirport)
    }

    init(flight: CKFlight? = nil) {
        self.id = flight?.flightID ?? UUID().uuidString
        self.flight = flight
    }

    func board(_ passenger: T) {
        passengers.insert(passenger)
    }

    func deplane(_ passenger: T) {
        passengers.remove(passenger)
    }
}
