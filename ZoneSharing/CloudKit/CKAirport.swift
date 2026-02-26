//
//  CKAirport.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

@Observable @MainActor public protocol CKAirport: Sociable {
    var id: String { get set }
    var name: String { get set }
    
    var flights: [String: Airplane<Contact>] { get set }
    associatedtype Passenger: Socialite
    
    func getCurrentPassenger() async throws -> Passenger
    func getFlights() -> Set<CKFlight>
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
