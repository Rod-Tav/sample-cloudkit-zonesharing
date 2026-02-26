//
//  ContactGroup.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

struct ContactGroup {
    let zone: CKNetwork
    let contacts: [Contact]
}

extension ContactGroup: Identifiable, Sociable {
    /// The verbose unique identifier
    var name: String {
        zone.zoneID.zoneName
    }

    /// The unique identifier
    var id: String {
        name
    }

    // MARK: - Sociable

    func socialID() -> String? {
        zone.zoneID.zoneName
    }

    func CKNetwork() -> CKNetwork? {
        zone
    }
}
