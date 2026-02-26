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
    func secureOtherData() -> SecureOtherData?
}

extension Securable {
    func secureID() -> String? { secureOtherData()?.zoneID.zoneName }
    func secureData() -> SecureData? { return nil }
    func secureOtherData() -> SecureOtherData? { return nil }
}
