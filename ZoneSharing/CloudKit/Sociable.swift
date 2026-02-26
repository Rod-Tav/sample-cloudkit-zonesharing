//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation
import CloudKit

public protocol Sociable: Identifiable, Sendable {
    associatedtype Passenger: Sociable
    
    var airplane: Airplane<Passenger> { get set }
    var airport: CKAirport { get set }
    
    func trip(from airport: Airport<Passenger>) -> CKFlight?
}

extension Sociable {
    func trip(from airport: Airport<Passenger>) async -> CKFlight? {
        return await CKFlight(zoneName: airport.name)
    }
}
