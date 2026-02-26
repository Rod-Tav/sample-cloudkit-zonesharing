//
//  CKFlight.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKFlight = CKRecordZone

public extension CKFlight {
    var flightID: String {
        self.zoneID.zoneName
    }
}
