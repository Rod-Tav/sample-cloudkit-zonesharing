//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

/// A contact
struct Contact: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let associatedStation: CKStation
}
