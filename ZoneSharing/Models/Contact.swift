//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

/// A contact
struct Contact: Identifiable, Sociable {
    typealias Passenger = Contact

    let id: String
    let name: String
    let phoneNumber: String

    var passenger: CKPassenger
    var gate: CKGate
    var airplane = Airplane<Contact>()
}

#if DEBUG
extension Contact {
    /// Preview/test convenience — creates a Contact without a real CKPassenger.
    static func preview(name: String, phoneNumber: String) -> Contact {
        let container = CKContainer(identifier: Config.containerIdentifier)
        return Contact(
            id: UUID().uuidString,
            name: name,
            phoneNumber: phoneNumber,
            passenger: CKPassenger(ticket: "SharedContact"),
            gate: CKGate(airport: container, terminal: container.privateCloudDatabase),
            airplane: Airplane<Contact>()
        )
    }
}
#endif
