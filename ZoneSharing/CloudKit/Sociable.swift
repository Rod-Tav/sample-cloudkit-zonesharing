//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

protocol Sociable: Identifiable {
    func socialID() -> String?
    func syncedData() -> SecureGroup?
    func secureSocialGroup() -> SecureSocialGroup?
}

extension Sociable {
    func socialID() -> String? { secureSocialGroup()?.zoneID.zoneName }
    func syncedData() -> SecureGroup? { return nil }
    func secureSocialGroup() -> SecureSocialGroup? { return nil }
}
