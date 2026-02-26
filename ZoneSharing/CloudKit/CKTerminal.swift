//
//  CKTerminal.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

public protocol CKTerminal: Sociable {
    var id: String { get set }
    var name: String { get set }
    var gate: any CKGate { get set }
    var flight: CKFlight { get set }
    
    func getPassenger(named: String) -> CKPassenger
    func getPassengers() -> Set<CKPassenger>

    func updateGate(old gate: any CKGate) -> any CKGate
    func getGates() -> Set<CKGate>
    
    func getFlight(from terminal: any CKTerminal) -> CKFlight
    func getFlights() -> Set<CKFlight>
    
}

extension CKTerminal {
    func getPassenger(named: String) -> CKPassenger {
        return CKPassenger(name: named)
    }
    
    func getFlight(from passenger: CKPassenger) -> CKFlight {
        return passenger.getFlight()
    }
        
}
