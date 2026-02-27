//
//  CKAirport.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

public actor CKAirport<T: Socialite>: Sociable {
    public let id = UUID()
    var code: CKGate
    
    var flights: [String: Airplane<Contact>]
    
    func getCurrentPassenger() async throws -> Passenger
    func getFlights() -> Set<CKFlight>
    func getPassengers() -> Set<CKPassenger>
}

extension CKAirport {
    func getCurrentPassenger() -> Passenger {
        return
    }
    
    func getFlights(from terminal: any CKTerminal) -> Set<CKFlight> {
        return terminal.getFlights()
    }
}

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
