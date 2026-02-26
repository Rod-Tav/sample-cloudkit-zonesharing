//
//  CKFlights.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

@Observable @MainActor
final class FlightStore {
    var flights: [String: Airplane<Contact>] = [:]
    var currentGate: String?
    
    var currentFlight: Airplane<Contact>? {
        guard let currentGate else { return nil }
        return flights[currentGate]
    }
    
    func updateFlight(_ zone: CKRecordZone, passengers: [Contact]) {
        let gate = zone.zoneID.zoneName
    }
    
    func reset() {
        flights = [:]
        currentGate = nil
    }
}
