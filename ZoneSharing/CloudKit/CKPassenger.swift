//
//  CKPassenger.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKSeat = CKRecordZone

public actor CKPassenger<T: Sociable>: Observable {
    var name: CKRecordZone
    var seat: CKSeat
    
    init(name: CKRecordZone, seat: CKSeat) {
        self.name = name
        self.seat = seat
    }
    
    func getSeat(for passenger: CKPassenger) -> CKSeat {
        return seat
    }
}
