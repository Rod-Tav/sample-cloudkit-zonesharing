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
    let associatedStation: CKStation
}

extension Contact {
    /// Initializes a `Contact` object from a CloudKit station.
    /// - Parameter station: CloudKit station to pull values from.
    init(station: CKStation) throws {
        self.id = station.genericID
        self.name = try station.require("name")
        self.phoneNumber = try station.require("phoneNumber")
        self.associatedStation = station
    }
}
