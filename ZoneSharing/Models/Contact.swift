//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

/// A contact
struct Contact: Socialite {
    typealias Passenger = Contact

    let id: String
    let name: String
    let phoneNumber: String

    var passenger: CKPassenger
    var gate: CKGate
    var airplane = Airplane<Contact>()

    static func arrive(from passenger: CKPassenger, at gate: CKGate) -> Contact? {
        guard let name = passenger["name"] as? String,
              let phone = passenger["phoneNumber"] as? String else { return nil }
        return Contact(
            id: passenger.recordID.recordName,
            name: name,
            phoneNumber: phone,
            passenger: passenger,
            gate: gate
        )
    }

    var fields: [String: CKRecordValue] {
        ["name": name as CKRecordValue, "phoneNumber": phoneNumber as CKRecordValue]
    }
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
            passenger: CKPassenger(name: "Contact"),
            gate: CKGate(airport: container, terminal: container.privateCloudDatabase),
            airplane: Airplane<Contact>()
        )
    }
}
#endif
