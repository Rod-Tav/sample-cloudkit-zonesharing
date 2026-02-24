//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

struct Contact: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let associatedRecord: CKRecord
}

extension Contact {
    /// Initializes a `Contact` object from a CloudKit record.
    /// - Parameter record: CloudKit record to pull values from.
    init(record: CKRecord) throws {
        self.id = record.genericID
        self.name = try record.require("name")
        self.phoneNumber = try record.require("phoneNumber")
        self.associatedRecord = record
    }
}
