//
//  ContactGroup.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

struct ContactGroup {
    let zone: CKDishZone
    let contacts: [Contact]
}

extension ContactGroup: Identifiable {
    /// The verbose unique identifier
    var name: String {
        zone.zoneID.zoneName
    }
    
    /// The unique identifier
    var id: String {
        name
    }
}
