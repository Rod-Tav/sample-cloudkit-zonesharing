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
    let associatedDish: CKDish
}

extension Contact {
    /// Initializes a `Contact` object from a CloudKit dish.
    /// - Parameter dish: CloudKit dish to pull values from.
    init(dish: CKDish) throws {
        self.id = dish.genericID
        self.name = try dish.require("name")
        self.phoneNumber = try dish.require("phoneNumber")
        self.associatedDish = dish
    }
}
