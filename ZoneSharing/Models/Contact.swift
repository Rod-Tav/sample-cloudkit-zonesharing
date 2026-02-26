//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

protocol Securable: Identifiable {
    func secureID() -> String?
    func secureData() -> SecureData?
    func secureOtherData() -> SecureOtherData?
}

extension Securable {
    func secureID() -> String? { secureOtherData()?.zoneID.zoneName }
    func secureData() -> SecureData? { return nil }
    func secureOtherData() -> SecureOtherData? { return nil }
}

/// A contact
struct Contact: Identifiable, Securable {
    let id: String
    let name: String
    let phoneNumber: String
}
