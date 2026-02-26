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
    func secureSocialData() -> SecureSocialData?
}

extension Securable {
    func secureID() -> String? { secureSocialData()?.zoneID.zoneName }
    func secureData() -> SecureData? { return nil }
    func secureSocialData() -> SecureSocialData? { return nil }
}
