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
    var flight: CKFlight { get set }
    
    func getName() -> String
    func getGate() -> CKGate
}

extension CKAirplane where Self: Sociable {
    func getName() -> String { return flight.zoneID.zoneName }
    
    func getPassengers() -> Set<CKPassenger<<#T: Sociable#>>> { return gate.getPassengers() }
    
}
