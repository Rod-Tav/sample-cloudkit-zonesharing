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
            passenger: CKPassenger(name: "Contact"),
            gate: vm.gate
        )
        let flight = CKFlight(zoneName: group)
        try await vm.gate.checkIn(contact, onto: flight)
        try await vm.refresh()
        isAddingContact = false
    }

    internal func shareGroup(_ manifest: Passengers<Contact>) async throws {
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
