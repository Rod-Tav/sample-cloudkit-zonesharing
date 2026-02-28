//
//  CKGate.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit
import SwiftUI

@Observable @MainActor public class CKGate: Sociable {
    var id = UUID()
    var name: String
    var airport: CKContainer
    var terminal: CKDatabase
    
    func getPassengers() async throws -> Set<CKPassenger>
    func depart(_ flight: CKFlight) async throws
}
    
//    init(airport: CKContainer, terminal: CKDatabase) {
//        self.airport = airport
//        self.terminal = terminal
//    }

extension CKGate {
    func getPassengers() async throws -> Set<CKPassenger> {
        return air
    }
    
    func getF
    
    func depart(_ flight: CKFlight, carrying records: [CKRecord]) async throws {
        try await terminal.save(zone)
        for passenger in flight.getPassengers() { try await terminal.save(record) }
    }

    func saveZone(_ zone: CKFlight) async throws {
        try await terminal.save(zone)
    }

    func saveRecord(_ record: CKRecord) async throws {
        try await terminal.save(record)
    }

    // MARK: - Check-in (departures — Socialite → CKRecord)

    /// Creates a CKRecord for a passenger and saves it to the given flight.
    @discardableResult
    func checkIn(_ fields: [String: CKRecordValue], onto flight: CKFlight, recordType: String = "SharedContact") async throws -> CKRecord {
        try await terminal.save(flight)
        let id = CKRecord.ID(zoneID: flight.zoneID)
        let record = CKRecord(recordType: recordType, recordID: id)
        for (key, value) in fields {
            record[key] = value
        }
        try await terminal.save(record)
        return record
    }

    /// Socialite-aware check-in: serializes the passenger's fields and saves to the flight.
    @discardableResult
    func checkIn<T: Socialite>(_ passenger: T, onto flight: CKFlight) async throws -> CKRecord {
        try await checkIn(passenger.fields as! [String : any CKRecordValue], onto: flight, recordType: passenger.name)
    }

    // MARK: - Share operations

    /// Fetches an existing `CKShare` on a zone, or creates a new one.
    func fetchOrCreateShare<T: Socialite>(manifest: Passengers<T>) async throws -> (CKShare, CKContainer) {
        let zone = await manifest.airplane.flight
        guard let zone else { throw InvalidShare() }
        guard let existingShare = zone.share else {
            let share = CKShare(recordZoneID: zone.zoneID)
            share[CKShare.SystemFieldKey.title] = "Contact Group: \(manifest.gate)"
            _ = try await terminal.modifyRecords(saving: [share], deleting: [])
            return (share, airport)
        }

        guard let share = try await terminal.record(for: existingShare.recordID) as? CKShare else {
            throw InvalidShare()
        }

        return (share, airport)
    }

    // MARK: - Fetching contacts

    /// Fetches all passengers by discovering zones on this gate's terminal.
    func getPassengers<T: Socialite>() async throws -> [Passengers<T>] {
        let zones = try await terminal.allRecordZones()
            .filter { $0.zoneID != CKFlight.default().zoneID }
        return try await fetch(in: zones)
    }
    
    /// Fetches grouped passengers for a given set of zones.
    func fetch<T: Socialite>(in zones: [CKFlight]) async throws -> [Passengers<T>] {
        guard !zones.isEmpty else {
            return []
        }

        var allFlights: [Passengers<T>] = []

        @Sendable func passengersInZone(_ zone: CKFlight) async throws -> [T] {
            if zone.zoneID == CKFlight.default().zoneID {
                return []
            }

            var allPassengers: [T] = []
            var awaitingChanges = true
            var nextChangeToken: CKServerChangeToken? = nil

            while awaitingChanges {
                let zoneChanges = try await terminal.recordZoneChanges(inZoneWith: zone.zoneID, since: nextChangeToken)
                let passengers = zoneChanges.modificationResultsByID.values
                    .compactMap { try? $0.get().record }
                    .compactMap { record -> T? in
                        T.arrive(from: record, at: self)
                    }
                allPassengers.append(contentsOf: passengers)

                awaitingChanges = zoneChanges.moreComing
                nextChangeToken = zoneChanges.changeToken
            }

            return allPassengers
        }

        try await withThrowingTaskGroup(of: (CKFlight, [T]).self) { group in
            for zone in zones {
                group.addTask {
                    (zone, try await passengersInZone(zone))
                }
            }

            for try await (zone, passengers) in group {
                let airplane = Airplane<T>(flight: zone)
                for passenger in passengers { await airplane.board(passenger) }

                let manifest = Passengers<T>(
                    id: airplane.id,
                    gate: await airplane.gate ?? zone.zoneID.zoneName,
                    passengers: await airplane.passengers,
                    airplane: airplane
                )
                allFlights.append(manifest)
            }
        }

        return allFlights
    }

    // MARK: - All flights (private + shared)

    @available(iOS 17.0, *)
    func getAllFlights<S: Sociable>(using _: S) async throws -> ([Passengers<S.Item>], [Passengers<S.Item>]) {
        let privateGate = CKGate(airport: airport, terminal: airport.privateCloudDatabase)
        let sharedGate = CKGate(airport: airport, terminal: airport.sharedCloudDatabase)

        async let p: [Passengers<S.Item>] = privateGate.fetchAll()
        async let s: [Passengers<S.Item>] = sharedGate.fetchAll()

        return (try await p, try await s)
    }

    // MARK: - Static helpers

    /// Creates a private-database gate for the given container identifier.
    static func privateGate(containerIdentifier: String) -> CKGate {
        let container = CKContainer(identifier: containerIdentifier)
        
        return CKGate(airport: container, terminal: container.privateCloudDatabase)
    }
}
