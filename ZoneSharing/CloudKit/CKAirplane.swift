//
//  CKFlight.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKFlight = CKRecordZone

public protocol CKAirplane: Sociable {
    var gate: any CKGate { get set }
    var flight: CKFlight { get set }
    
    func getName() -> String
    func getPassengers() -> Set<CKPassenger>
}

extension CKAirplane {
    func getName() -> String { return flight.zoneID.zoneName }
    
    func getPassengers() -> Set<CKPassenger> { return gate.getPassengers() }
    
}
