//
//  Socialite.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation
import CloudKit

@MainActor public protocol Socialite: Sociable {
    associatedtype Passenger: Socialite

    var passenger: CKPassenger { get }
    var airplane: Airplane<Passenger> { get set }
    var gate: CKGate { get set }

    /// Deserialize from a CloudKit record. Returns nil if the record is malformed.
    static func arrive(from passenger: CKPassenger, at gate: CKGate) -> Self?

    /// The CloudKit-serializable fields for this passenger.
    var fields: [String: CKPassenger] { get }

    func getTrip(from gate: CKGate) async -> CKFlight?

    func getAllFlights<S: Sociable>(using data: S) async throws -> (
        private: [Passengers<Self>],
        shared: [Passengers<Self>]
    ) where S.Item == Self
}

extension Socialite {
    func getTrip(from gate: CKGate) async -> CKFlight? {
        return await airplane.flight
    }
    
    func getAllFlights<S: Sociable>(using data: S) async throws -> (
        private: [Passengers<Self>],
        shared: [Passengers<Self>]
    ) where S.Item == Self {
        let airport = data.gate.airport
        
        let privateGate = CKGate(airport: airport, terminal: airport.privateCloudDatabase)
        let sharedGate = CKGate(airport: airport, terminal: airport.sharedCloudDatabase)
        
        async let p: [Passengers<Self>] = privateGate.fetchAll()
        async let s: [Passengers<Self>] = sharedGate.fetchAll()
        
        return (private: try await p, shared: try await s)
    }
}
