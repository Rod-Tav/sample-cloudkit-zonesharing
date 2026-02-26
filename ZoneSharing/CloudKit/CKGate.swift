//
//  CKGate.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit

public struct CKGate: Sendable {
    let airport: CKContainer
    let terminal: CKDatabase

    // MARK: - Flight operations (saving to CloudKit)

    func depart(_ zone: CKFlight, carrying records: [CKRecord]) async throws {
        try await terminal.save(zone)
        for record in records { try await terminal.save(record) }
    }

    func saveZone(_ zone: CKFlight) async throws {
        try await terminal.save(zone)
    }

    func saveRecord(_ record: CKRecord) async throws {
        try await terminal.save(record)
    }

    // MARK: - Check-in (departures — Sociable → CKRecord)

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

    // MARK: - Passenger processing (arrivals — CKRecord → fields)

    /// Extracts a required field from a passenger record, throwing if the key is missing or type doesn't match.
    func require<T>(from record: CKRecord, key: String) throws -> T {
        guard let value = record[key] as? T else {
            throw InvalidPassenger(record)
        }
        return value
    }

    /// Returns the generic ID (recordName) for a passenger record.
    func passengerID(for record: CKRecord) -> String {
        record.recordID.recordName
    }

    // MARK: - Share operations

    /// Fetches an existing `CKShare` on a zone, or creates a new one.
    func fetchOrCreateShare(manifest: FlightManifest) async throws -> (CKShare, CKContainer) {
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

    /// Fetches all contacts by discovering zones on this gate's terminal.
    func fetchAllContacts() async throws -> [FlightManifest] {
        let zones = try await terminal.allRecordZones()
            .filter { $0.zoneID != CKFlight.default().zoneID }
        return try await fetchContacts(in: zones)
    }

    /// Fetches grouped contacts for a given set of zones.
    func fetchContacts(in zones: [CKFlight]) async throws -> [FlightManifest] {
        guard !zones.isEmpty else {
            return []
        }

        var allFlights: [FlightManifest] = []

        @Sendable func contactsInZone(_ zone: CKFlight) async throws -> [Contact] {
            if zone.zoneID == CKFlight.default().zoneID {
                return []
            }

            var allContacts: [Contact] = []
            var awaitingChanges = true
            var nextChangeToken: CKServerChangeToken? = nil

            while awaitingChanges {
                let zoneChanges = try await terminal.recordZoneChanges(inZoneWith: zone.zoneID, since: nextChangeToken)
                let contacts = zoneChanges.modificationResultsByID.values
                    .compactMap { try? $0.get().record }
                    .compactMap { record -> Contact? in
                        guard let name: String = try? self.require(from: record, key: "name"),
                              let phone: String = try? self.require(from: record, key: "phoneNumber") else {
                            return nil
                        }
                        return Contact(
                            id: self.passengerID(for: record),
                            name: name,
                            phoneNumber: phone,
                            passenger: record,
                            gate: self
                        )
                    }
                allContacts.append(contentsOf: contacts)

                awaitingChanges = zoneChanges.moreComing
                nextChangeToken = zoneChanges.changeToken
            }

            return allContacts
        }

        try await withThrowingTaskGroup(of: (CKFlight, [Contact]).self) { group in
            for zone in zones {
                group.addTask {
                    (zone, try await contactsInZone(zone))
                }
            }

            for try await (zone, contacts) in group {
                let airplane = Airplane<Contact>(flight: zone)
                for contact in contacts { await airplane.board(contact) }

                let manifest = FlightManifest(
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

    // MARK: - Static helpers

    /// Creates a private-database gate for the given container identifier.
    static func privateGate(containerIdentifier: String) -> CKGate {
        let container = CKContainer(identifier: containerIdentifier)
        return CKGate(airport: container, terminal: container.privateCloudDatabase)
    }

    static func fetchAllFlights(airport: CKContainer) async throws -> (private: [FlightManifest], shared: [FlightManifest]) {
        let privateGate = CKGate(airport: airport, terminal: airport.privateCloudDatabase)
        let sharedGate = CKGate(airport: airport, terminal: airport.sharedCloudDatabase)
        async let p = privateGate.fetchAllContacts()
        async let s = sharedGate.fetchAllContacts()
        return (private: try await p, shared: try await s)
    }

    // MARK: - Errors

    struct InvalidShare: LocalizedError {
        var errorDescription: String? { "Invalid or missing CKShare" }
    }

    struct InvalidPassenger: LocalizedError {
        let record: CKRecord

        init(_ record: CKRecord) { self.record = record }

        var errorDescription: String? {
            "Invalid passenger '\(record.recordType)' (\(record.recordID.recordName))"
        }
        var failureReason: String? { "The passenger record contains mismatching types" }
        var recoverySuggestion: String? { "Ensure the record field types match" }
        var helpAnchor: String? { "The passenger record is missing a valid field" }
    }
}
