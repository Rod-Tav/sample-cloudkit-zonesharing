//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

protocol Securable: Identifiable {
    func secureID() -> String?
    func secureData() -> SecureData?
    func SecureSocialGroup() -> SecureSocialGroup?
}

extension Securable {
    func secureID() -> String? { SecureSocialGroup()?.zoneID.zoneName }
    func secureData() -> SecureData? { return nil }
    func SecureSocialGroup() -> SecureSocialGroup? { return nil }
}
