//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

protocol Sociable: Identifiable, Sendable {
    func getSocialID() -> String?
    func getStation() -> CKStation?
    func getNetwork() -> CKNetwork?
}

extension Sociable {
    func getSocialID(_ station: CKStation) -> String? { getNetwork()?.socialID }
    func getStation() -> CKStation? { return nil }
    func getNetwork(_ station: CKStation) -> CKNetwork? { return nil }
}
