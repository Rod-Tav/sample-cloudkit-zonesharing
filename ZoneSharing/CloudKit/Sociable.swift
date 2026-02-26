//
//  Sociable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation
import CloudKit

public protocol Sociable: Identifiable, Sendable {
    associatedtype Passenger: Sociable

    var passenger: CKPassenger { get }
    var airplane: Airplane<Passenger> { get set }
    var gate: CKGate { get set }

    func trip(from gate: CKGate) async -> CKFlight?
}

extension Sociable {
    func trip(from gate: CKGate) async -> CKFlight? {
        return await airplane.flight
    }
}
