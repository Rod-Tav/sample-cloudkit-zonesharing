//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

/// A contact
struct Contact: Identifiable, Securable {
    let id: String
    let name: String
    let phoneNumber: String
}
