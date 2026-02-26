//
//  CKPassenger.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKPassenger = CKRecord

@MainActor public extension CKPassenger {
    convenience init(name: String) {
        self.init(recordType: name)
    }
    
    func getName() -> String {
        return self.recordType
    }
    
    func getFlight(from gate: CKGate) -> CKFlight {
        return CKFlight(zoneName: gate.name)
    }
}
