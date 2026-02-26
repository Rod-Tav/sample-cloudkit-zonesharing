//
//  ContentView-Functions.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation
import CloudKit

extension ContentView {
    internal func addContact(name: String, phoneNumber: String, group: String) async throws {
        let contact = Contact(
            id: UUID().uuidString,
            name: name,
            phoneNumber: phoneNumber,
            passenger: CKPassenger(ticket: "SharedContact"),
            gate: vm.gate
        )
        let flight = CKFlight(zoneName: group)
        let fields: [String: CKRecordValue] = [
            "name": contact.name as CKRecordValue,
            "phoneNumber": contact.phoneNumber as CKRecordValue
        ]
        try await vm.gate.checkIn(fields, onto: flight)
        try await vm.refresh()
        isAddingContact = false
    }

    internal func shareGroup(_ manifest: FlightManifest) async throws {
        isProcessingShare = true

        do {
            let (share, container) = try await vm.gate.fetchOrCreateShare(manifest: manifest)
            isProcessingShare = false
            activeShare = share
            activeContainer = container
            isSharing = true
        } catch {
            debugPrint("Error sharing contact record: \(error)")
        }
    }
}
