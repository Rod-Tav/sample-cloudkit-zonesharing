//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

public protocol Sociable: Identifiable, Sendable {
    associatedtype Passenger: Identifiable
    
    var airplane: Airplane<Passenger> { get set }
    var airport: CKAirport { get set }
    
    func trip(from airport: CKAirport) -> CKFlight?
}

extension Sociable {
    func trip(from airport: CKAirport) -> CKFlight? {
        return CKFlight(zoneID: airport.ID)
    }
}
